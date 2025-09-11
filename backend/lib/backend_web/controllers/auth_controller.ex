defmodule BackendWeb.AuthController do
  use BackendWeb, :controller

  alias Backend.Repo
  alias Backend.Users.User

  # --- Third-party dummy logins ---
  def google_login(conn, %{"id_token" => _id_token}) do
    user_attrs = %{
      google_id: "dummy_google_user_id_from_token",
      name: "Google User",
      email: "google@example.com"
    }

    upsert_user(conn, user_attrs)
  end

  def facebook_login(conn, %{"access_token" => _access_token}) do
    user_attrs = %{
      facebook_id: "dummy_facebook_user_id_from_token",
      name: "Facebook User",
      email: "facebook@example.com"
    }

    upsert_user(conn, user_attrs)
  end

  def line_login(conn, %{"access_token" => _access_token}) do
    user_attrs = %{
      line_id: "dummy_line_user_id_from_token",
      name: "LINE User"
    }

    upsert_user(conn, user_attrs)
  end

  # --- Update user profile ---
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

  # --- Private helper for upsert ---
  defp upsert_user(conn, user_attrs) do
    # Determine the provider field dynamically
    provider_field =
      cond do
        Map.has_key?(user_attrs, :google_id) -> :google_id
        Map.has_key?(user_attrs, :facebook_id) -> :facebook_id
        Map.has_key?(user_attrs, :line_id) -> :line_id
      end

    # Try to fetch user by provider ID only
    user =
      case Repo.get_by(User, [{provider_field, Map.get(user_attrs, provider_field)}]) do
        nil ->
          %User{}
          |> User.third_party_changeset(user_attrs)
          |> Repo.insert!()

        user ->
          user
      end

    complete =
      user.surname && user.surname != "" && user.email && user.email != ""

    {:ok, token, _claims} = Backend.Guardian.encode_and_sign(user)

    conn
    |> put_status(
      if Repo.get_by(User, [{provider_field, Map.get(user_attrs, provider_field)}]),
        do: 200,
        else: 201
    )
    |> json(%{
      user: %{
        id: user.id,
        name: user.name,
        surname: user.surname,
        email: user.email,
        birthday: user.birthday,
        gender: user.gender,
        complete: complete
      },
      token: token
    })
  end

  # Helper to render changeset errors
  defp traverse_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
