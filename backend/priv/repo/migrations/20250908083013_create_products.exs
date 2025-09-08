defmodule MarketplaceBackend.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string
      add :description, :string
      add :price, :decimal
      add :seller_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:products, [:seller_id])
  end
end
