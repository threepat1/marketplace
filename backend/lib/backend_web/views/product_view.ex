defmodule BackendWeb.ProductJSON do
  alias Backend.Products.Product

  def index(%{products: products}) do
    %{data: for(product <- products, do: product_data(product))}
  end

  def show(%{product: product}) do
    %{data: product_data(product)}
  end

  defp product_data(%Product{} = product) do
    %{
      id: product.id,
      name: product.name,
      start_price: product.start_price,
      finished_price: product.finished_price,
      end_time: product.end_time,
      description: product.description,
      image_link: product.image_link,
      winning_price: product.winning_price,
      winning_bid_user_id: product.winning_bid_user_id,
      is_auction_ended: product.is_auction_ended
    }
  end
end
