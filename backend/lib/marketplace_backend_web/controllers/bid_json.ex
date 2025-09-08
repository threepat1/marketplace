defmodule MarketplaceBackendWeb.BidJSON do
  alias MarketplaceBackend.Bids.Bid

  @doc """
  Renders a list of bids.
  """
  def index(%{bids: bids}) do
    %{data: for(bid <- bids, do: data(bid))}
  end

  @doc """
  Renders a single bid.
  """
  def show(%{bid: bid}) do
    %{data: data(bid)}
  end

  defp data(%Bid{} = bid) do
    %{
      id: bid.id,
      amount: bid.amount
    }
  end
end
