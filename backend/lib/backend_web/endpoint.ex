defmodule BackendWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :backend

  # Serve the static files from the priv/static directory.
  if code_reloading? do
    plug(Plug.Static,
      at: "/",
      from: :backend,
      gzip: false,
      only: ~w(assets fonts images favicon.ico robots.txt)
    )
  end

  plug(Plug.Logger)

  plug(Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Jason
  )

  plug(Plug.MethodOverride)
  plug(Plug.Head)

  plug(Plug.Session,
    store: :cookie,
    key: "_backend_key",
    signing_salt: "xgXdFlMsibWHqRpV0W3c/hlaLb/rOVyE3Mu3qzk59ZZSmyBUKPwiMXYQ6jUZ6/8F"
  )

  plug(BackendWeb.Router)
end
