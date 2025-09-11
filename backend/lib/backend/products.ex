defmodule Backend.Products do
  import Ecto.Query, warn: false
  alias Backend.Repo
  alias Backend.Products.Product

  # --- LIST ---
  def list_products(user_id \\ nil) do
    query =
      from(p in Product,
        order_by: [desc: p.inserted_at]
      )

    case user_id do
      nil -> Repo.all(query)
      user_id -> query |> where([p], p.user_id == ^user_id) |> Repo.all()
    end
  end

  # --- GET ONE ---
  def get_product!(id), do: Repo.get!(Product, id)

  # --- CREATE ---
  def create_product(attrs \\ %{}) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  # --- UPDATE ---
  def update_product(%Product{} = product, attrs) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
  end

  # --- DELETE ---
  def delete_product(%Product{} = product) do
    Repo.delete(product)
  end
end
