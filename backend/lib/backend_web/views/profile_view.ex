defmodule BackendWeb.ProfileJSON do
  def profile(%{user: user}) do
    %{
      id: user.id,
      name: user.name,
      surname: user.surname,
      email: user.email,
      birthday: user.birthday,
      gender: user.gender
    }
  end
end
