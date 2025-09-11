defmodule Backend.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:name, :string, null: false)
      add(:start_price, :float, null: false)
      add(:finished_price, :float)
      add(:end_time, :utc_datetime, null: false)
      add(:description, :text)
      add(:image_link, :string)
      add(:winning_price, :float)
      add(:winning_bid_user_id, :uuid)
      add(:is_auction_ended, :boolean, default: false)

      timestamps()
    end
  end
end
