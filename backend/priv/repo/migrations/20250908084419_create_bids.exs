defmodule MarketplaceBackend.Repo.Migrations.CreateBids do
  use Ecto.Migration

  def change do
    create table(:bids) do
      add :amount, :decimal
      add :product_id, references(:products, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:bids, [:product_id])
    create index(:bids, [:user_id])
  end
end
