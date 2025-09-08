defmodule MarketplaceWeb.HelloController do
  use MarketplaceWeb, :controller

  def index(conn, _params) do
    json(conn, %{hello: "world"})
  end
end
