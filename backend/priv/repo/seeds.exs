# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     MarketplaceBackend.Repo.insert!(%MarketplaceBackend.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias MarketplaceBackend.Accounts
alias MarketplaceBackend.Catalog

# Create users
{:ok, user1} = Accounts.create_user(%{name: "John Doe", email: "john.doe@example.com", password: "password123"})
{:ok, user2} = Accounts.create_user(%{name: "Jane Doe", email: "jane.doe@example.com", password: "password123"})

# Create products
Catalog.create_product(%{name: "Elixir Mug", description: "A nice mug with the Elixir logo.", price: 10.0, seller_id: user1.id})
Catalog.create_product(%{name: "Phoenix T-Shirt", description: "A cool t-shirt with the Phoenix logo.", price: 20.0, seller_id: user1.id})
Catalog.create_product(%{name: "Ecto Sticker", description: "A sticker with the Ecto logo.", price: 2.0, seller_id: user2.id})
