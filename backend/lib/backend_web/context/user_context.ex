defmodule Backend.Users do
  alias Backend.Repo
  alias Backend.Users.User

  # Upsert user for third-party login
  def upsert(attrs) do
    case Repo.get_by(User, Map.take(attrs, [:google_id, :facebook_id, :line_id])) do
      %User{} = user ->
        {:ok, user}

      nil ->
        %User{}
        |> User.changeset(attrs)
        |> Repo.insert()
    end
  end

  def update_profile(%User{} = user, attrs) do
    user
    |> User.update_changeset(attrs)
    |> Repo.update()
  end
end
