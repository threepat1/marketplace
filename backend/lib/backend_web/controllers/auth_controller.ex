defmodule BackendWeb.AuthController do
  use BackendWeb, :controller

  alias Backend.Guardian
  alias Backend.Repo
  alias Backend.Users.User

  # --- Third-party dummy logins ---

  def google_login(conn, %{"id_token" => id_token}) do
    with {:ok, %Req.Response{status: 200, body: body}} <-
           Req.get("https://oauth2.googleapis.com/tokeninfo", params: [id_token: id_token]),
         %{"sub" => google_id} <- body do
      user_attrs = %{
        google_id: google_id,
        name: body["name"],
        email: body["email"]
      }

      upsert_user(conn, user_attrs)
    else
      _ ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid Google token"})
    end
  end

  def facebook_login(conn, %{"access_token" => access_token}) do
    with {:ok, %Req.Response{status: 200, body: body}} <-
           Req.get("https://graph.facebook.com/me",
             params: [fields: "id,name,email", access_token: access_token]
           ),
         %{"id" => facebook_id} <- body do
      user_attrs = %{
        facebook_id: facebook_id,
        name: body["name"],
        email: body["email"]
      }

      upsert_user(conn, user_attrs)
    else
      _ ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid Facebook token"})
    end
  end

  def line_login(conn, %{"access_token" => access_token}) do
    with {:ok, %Req.Response{status: 200}} <-
           Req.get("https://api.line.me/oauth2/v2.1/verify", params: [access_token: access_token]),
         {:ok, %Req.Response{status: 200, body: body}} <-
           Req.get("https://api.line.me/v2/profile",
             headers: [{"authorization", "Bearer #{access_token}"}]
           ),
         %{"userId" => line_id, "displayName" => name} <- body do
      user_attrs = %{
        line_id: line_id,
        name: name
      }

      upsert_user(conn, user_attrs)
    else
      _ ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid LINE token"})
    end
  end

  def update_profile(conn, %{"id" => id, "user" => user_params}) do
    case Repo.get(User, id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "User not found"})

      user ->
        user
        |> User.update_changeset(user_params)
        |> Repo.update()
        |> case do
          {:ok, updated_user} ->
            conn
            |> json(%{user: updated_user})

          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{errors: traverse_errors(changeset)})
        end
    end
  end

  # --- Helpers ---

  defp upsert_user(conn, attrs) do
    case Repo.get_by(User, email: attrs[:email]) do
      nil ->
        %User{}
        |> User.third_party_changeset(attrs)
        |> Repo.insert()
        |> case do
          {:ok, user} ->
            {:ok, token, _claims} = Guardian.encode_and_sign(user)
            json(conn, %{token: token, user: user, complete: profile_complete?(user)})

          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{errors: traverse_errors(changeset)})
        end

      user ->
        user
        |> User.third_party_changeset(attrs)
        |> Repo.update()
        |> case do
          {:ok, user} ->
            {:ok, token, _claims} = Guardian.encode_and_sign(user)
            json(conn, %{token: token, user: user, complete: profile_complete?(user)})

          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{errors: traverse_errors(changeset)})
        end
    end
  end

  defp profile_complete?(%User{} = user) do
    Enum.all?([user.surname, user.email], fn value ->
      is_binary(value) and String.trim(value) != ""
    end)
  end

  defp traverse_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
