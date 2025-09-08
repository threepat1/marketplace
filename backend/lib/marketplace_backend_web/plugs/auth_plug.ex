defmodule MarketplaceBackendWeb.AuthPlug do
  import Plug.Conn
  import Phoenix.Controller

  def init(opts), do: opts

  def call(conn, _opts) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, claims} <- Joken.verify_and_validate(token, %{}),
         %{"id" => user_id} <- claims,
         user <- MarketplaceBackend.Accounts.get_user!(user_id) do
      conn
      |> assign(:current_user, user)
    else
      _ ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Unauthorized"})
        |> halt()
    end
  end
end
