defmodule BackendWeb.Router do
  use BackendWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :auth do
    plug(BackendWeb.AuthPipeline)
  end

  scope "/api", BackendWeb do
    pipe_through(:api)
    resources("/products", ProductController, only: [:index, :show])
    post("/auth/google", AuthController, :google_login)
    post("/auth/facebook", AuthController, :facebook_login)
    post("/auth/line", AuthController, :line_login)
  end

  scope "/api", BackendWeb do
    pipe_through([:api, :auth])
    resources("/products", ProductController, only: [:create, :update, :delete])
  end
end
