defmodule Backend.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset
  alias Backend.Products.Product

  @primary_key {:id, :binary_id, autogenerate: true}
  @timestamps_type :utc_datetime

  schema "products" do
    field(:name, :string)
    field(:start_price, :float)
    field(:finished_price, :float)
    field(:end_time, :utc_datetime)
    field(:description, :string)
    field(:image_link, :string)
    field(:winning_price, :float)
    field(:winning_bid_user_id, :binary_id)
    field(:is_auction_ended, :boolean, default: false)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(%Product{} = product, attrs) do
    product
    |> cast(attrs, [
      :name,
      :start_price,
      :finished_price,
      :end_time,
      :description,
      :image_link,
      :winning_bid_user_id,
      :is_auction_ended
    ])
    |> validate_required([:name, :start_price, :end_time])
  end
end
