defmodule Backend.Guardian do
  use Guardian, otp_app: :backend

  alias Backend.Repo
  alias Backend.Users.User

  # Encode the user into a token
  def subject_for_token(%User{id: id}, _claims), do: {:ok, id}
  def subject_for_token(_, _), do: {:error, :reason}

  # Decode the token into a user
  def resource_from_claims(%{"sub" => id}) do
    case Repo.get(User, id) do
      nil -> {:error, :resource_not_found}
      user -> {:ok, user}
    end
  end

  def resource_from_claims(_), do: {:error, :invalid_claims}
end
