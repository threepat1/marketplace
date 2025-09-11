defmodule Backend.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add(:id, :uuid, primary_key: true)

      # Store third-party IDs for login and linking accounts
      add(:google_id, :string)
      add(:facebook_id, :string)
      add(:line_id, :string)

      # Fields for the profile completion form
      add(:name, :string)
      add(:surname, :string)
      add(:email, :string)
      add(:birthday, :string)
      add(:gender, :string)

      timestamps()
    end

    # Add unique indexes to prevent duplicate users from the same provider.
    create(unique_index(:users, [:google_id]))
    create(unique_index(:users, [:facebook_id]))
    create(unique_index(:users, [:line_id]))
  end
end
