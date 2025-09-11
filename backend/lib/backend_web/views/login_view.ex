defmodule BackendWeb.LoginJSON do
  def login(%{user: user, complete: complete}) do
    %{
      user: user_data(user),
      complete: complete
    }
  end

  defp user_data(user) do
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
