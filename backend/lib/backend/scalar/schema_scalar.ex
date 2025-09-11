defmodule BackendWeb.Schema.Scalars do
  use Absinthe.Schema.Notation

  scalar :datetime, description: "ISO8601 DateTime" do
    parse(&parse_datetime/1)
    serialize(&serialize_datetime/1)
  end

  defp parse_datetime(%Absinthe.Blueprint.Input.String{value: value}) do
    case DateTime.from_iso8601(value) do
      {:ok, dt, _offset} -> {:ok, dt}
      _ -> :error
    end
  end

  defp serialize_datetime(%DateTime{} = dt), do: DateTime.to_iso8601(dt)
end
