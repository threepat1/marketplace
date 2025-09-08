defmodule MarketplaceBackendWeb.Router do
  use MarketplaceBackendWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_auth do
    plug MarketplaceBackendWeb.AuthPlug
  end

  scope "/api", MarketplaceBackendWeb do
    pipe_through :api

    post "/login", AuthController, :login
    resources "/users", UserController, except: [:new, :edit]
  end

  scope "/api", MarketplaceBackendWeb do
    pipe_through [:api, :api_auth]

    resources "/products", ProductController, except: [:new, :edit]
    resources "/bids", BidController, except: [:new, :edit]
  end
end
