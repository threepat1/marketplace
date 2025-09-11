defmodule BackendWeb.Plugs.AuthenticateJWT do
  import Plug.Conn
  alias Backend.Guardian

  def init(opts), do: opts

  def call(conn, _opts) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, user, _claims} <- Guardian.resource_from_token(token) do
      Absinthe.Plug.put_options(conn, context: %{current_user: user})
    else
      _ ->
        conn
        |> send_resp(401, "Unauthorized")
        |> halt()
    end
  end
end
