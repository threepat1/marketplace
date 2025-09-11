defmodule BackendWeb.ProductController do
  use BackendWeb, :controller

  alias Backend.Products
  alias Backend.Products.Product

  # GET /api/products
  def index(conn, _params) do
    products = Products.list_products()
    render(conn, :index, products: products)
  end

  # GET /api/products/:id
  def show(conn, %{"id" => id}) do
    product = Products.get_product!(id)
    render(conn, :show, product: product)
  end

  # POST /api/products
  def create(conn, %{"product" => product_params}) do
    case Products.create_product(product_params) do
      {:ok, product} ->
        conn
        |> put_status(:created)
        |> render(:show, product: product)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(BackendWeb.ErrorJSON, :error, changeset: changeset)
    end
  end

  # PATCH /api/products/:id
  def update(conn, %{"id" => id, "product" => product_params}) do
    product = Products.get_product!(id)

    case Products.update_product(product, product_params) do
      {:ok, product} ->
        render(conn, :show, product: product)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(BackendWeb.ErrorJSON, :error, changeset: changeset)
    end
  end

  # DELETE /api/products/:id
  def delete(conn, %{"id" => id}) do
    product = Products.get_product!(id)

    case Products.delete_product(product) do
      {:ok, _product} ->
        send_resp(conn, :no_content, "")

      {:error, _changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(BackendWeb.ErrorJSON, :error, message: "Unable to delete product")
    end
  end
end
