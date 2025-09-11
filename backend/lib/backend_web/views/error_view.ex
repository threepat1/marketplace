defmodule BackendWeb.ErrorView do
  use BackendWeb.View

  def render("error.json", %{changeset: changeset}) do
    %{errors: Ecto.Changeset.traverse_errors(changeset, & &1)}
  end
end
