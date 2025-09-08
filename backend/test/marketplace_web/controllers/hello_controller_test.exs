defmodule MarketplaceWeb.HelloControllerTest do
  use MarketplaceWeb.ConnCase

  test "GET /api/hello", %{conn: conn} do
    conn = get(conn, "/api/hello")
    assert json_response(conn, 200) == %{"hello" => "world"}
  end
end
