defmodule BackendWeb.AuthErrorHandler do
  import Plug.Conn

  # conn: Plug.Conn
  # type: atom (e.g., :unauthorized)
  # reason: any
  def auth_error(conn, _type, _reason) do
    body = Jason.encode!(%{error: "Unauthorized"})

    conn
    |> Plug.Conn.put_resp_content_type("application/json")
    |> Plug.Conn.send_resp(401, body)
  end
end
