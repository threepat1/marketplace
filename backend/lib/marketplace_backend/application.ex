defmodule MarketplaceBackend.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MarketplaceBackendWeb.Telemetry,
      MarketplaceBackend.Repo,
      {DNSCluster, query: Application.get_env(:marketplace_backend, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: MarketplaceBackend.PubSub},
      # Start a worker by calling: MarketplaceBackend.Worker.start_link(arg)
      # {MarketplaceBackend.Worker, arg},
      # Start to serve requests, typically the last entry
      MarketplaceBackendWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MarketplaceBackend.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MarketplaceBackendWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
