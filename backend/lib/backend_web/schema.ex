defmodule BackendWeb.Schema do
  use Absinthe.Schema
  import_types(BackendWeb.Schema.Scalars)

  alias Backend.Products
  alias Backend.Users

  # Types
  object :user do
    field(:id, :id)
    field(:name, :string)
    field(:surname, :string)
    field(:email, :string)
    field(:birthday, :string)
    field(:gender, :string)
  end

  object :product do
    field(:id, :id)
    field(:name, :string)
    field(:start_price, :float)
    field(:finished_price, :float)
    field(:end_time, :datetime)
    field(:description, :string)
    field(:image_link, :string)
    field(:winning_price, :float)
    field(:winning_bid_user_id, :id)
    field(:is_auction_ended, :boolean)
    field(:user_id, :id)
  end

  # Queries
  query do
    field :products, list_of(:product) do
      arg(:user_id, :id)

      resolve(fn args, _ ->
        {:ok, Products.list_products(args)}
      end)
    end
  end

  # Mutations
  mutation do
    field :create_product, type: :product do
      arg(:name, non_null(:string))
      arg(:start_price, non_null(:float))
      arg(:finished_price, :float)
      arg(:end_time, non_null(:datetime))
      arg(:description, :string)
      arg(:image_link, :string)

      resolve(fn args, %{context: %{current_user: user}} ->
        Products.create_product(args, user)
      end)
    end

    field :update_profile, type: :user do
      arg(:name, :string)
      arg(:surname, :string)
      arg(:email, :string)
      arg(:birthday, :string)
      arg(:gender, :string)

      resolve(fn args, %{context: %{current_user: user}} ->
        case Users.update_profile(user, args) do
          {:ok, updated} -> {:ok, updated}
          {:error, _} -> {:error, "Update failed"}
        end
      end)
    end
  end
end
