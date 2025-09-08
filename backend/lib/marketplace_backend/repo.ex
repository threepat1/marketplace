defmodule MarketplaceBackend.Repo do
  use Ecto.Repo,
    otp_app: :marketplace_backend,
    adapter: Ecto.Adapters.Postgres
end
