defmodule MarketplaceBackendWeb.BidControllerTest do
  use MarketplaceBackendWeb.ConnCase

  import MarketplaceBackend.BidsFixtures

  alias MarketplaceBackend.Bids.Bid

  @create_attrs %{
    amount: "120.5"
  }
  @update_attrs %{
    amount: "456.7"
  }
  @invalid_attrs %{amount: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all bids", %{conn: conn} do
      conn = get(conn, ~p"/api/bids")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create bid" do
    test "renders bid when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/bids", bid: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/bids/#{id}")

      assert %{
               "id" => ^id,
               "amount" => "120.5"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/bids", bid: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update bid" do
    setup [:create_bid]

    test "renders bid when data is valid", %{conn: conn, bid: %Bid{id: id} = bid} do
      conn = put(conn, ~p"/api/bids/#{bid}", bid: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/bids/#{id}")

      assert %{
               "id" => ^id,
               "amount" => "456.7"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, bid: bid} do
      conn = put(conn, ~p"/api/bids/#{bid}", bid: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete bid" do
    setup [:create_bid]

    test "deletes chosen bid", %{conn: conn, bid: bid} do
      conn = delete(conn, ~p"/api/bids/#{bid}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/bids/#{bid}")
      end
    end
  end

  defp create_bid(_) do
    bid = bid_fixture()
    %{bid: bid}
  end
end
