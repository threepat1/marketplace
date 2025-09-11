defmodule BackendWeb.ErrorJSON do
  import Ecto.Changeset

  # Handles generic errors
  def error(%{changeset: %Ecto.Changeset{} = changeset}) do
    %{errors: translate_errors(changeset)}
  end

  def error(%{message: message}) do
    %{errors: %{detail: message}}
  end

  def error(_assigns) do
    %{errors: %{detail: "Unknown error"}}
  end

  # Turn Ecto.Changeset errors into a JSON-friendly map
  defp translate_errors(changeset) do
    traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
