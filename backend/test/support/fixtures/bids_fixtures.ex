defmodule MarketplaceBackend.BidsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MarketplaceBackend.Bids` context.
  """

  @doc """
  Generate a bid.
  """
  def bid_fixture(attrs \\ %{}) do
    {:ok, bid} =
      attrs
      |> Enum.into(%{
        amount: "120.5"
      })
      |> MarketplaceBackend.Bids.create_bid()

    bid
  end
end
