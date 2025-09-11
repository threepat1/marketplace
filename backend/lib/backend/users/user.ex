defmodule Backend.Users.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Backend.Users.User

  # Tell Ecto to use binary IDs (UUIDs) for the primary key.
  @primary_key {:id, :binary_id, autogenerate: true}

  schema "users" do
    field(:google_id, :string)
    field(:facebook_id, :string)
    field(:line_id, :string)
    field(:name, :string)
    field(:surname, :string)
    field(:email, :string)
    field(:birthday, :string)
    field(:gender, :string)

    timestamps(type: :utc_datetime)
  end

  # Changeset for handling new users from third-party logins.
  def third_party_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:google_id, :facebook_id, :line_id, :name, :email, :surname])
    |> validate_required([:name])
    |> unique_constraint(:google_id)
    |> unique_constraint(:facebook_id)
    |> unique_constraint(:line_id)
  end

  # Changeset for updating a user's profile.
  def update_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :surname, :email, :birthday, :gender])
    |> validate_required([:name, :surname, :email])
  end
end
