defmodule MarketplaceBackendWeb.AuthController do
  use MarketplaceBackendWeb, :controller
  alias MarketplaceBackend.Accounts
  alias MarketplaceBackend.Accounts.User

  def login(conn, %{"email" => email, "password" => password}) do
    with %User{} = user <- Accounts.get_user_by_email(email),
         true <- Bcrypt.verify_pass(password, user.password_hash) do
      # Generate token
      {:ok, token} = Joken.encode_and_sign(%{id: user.id}, %{})

      conn
      |> put_status(:ok)
      |> json(%{token: token})
    else
      _ ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid email or password"})
    end
  end
end
