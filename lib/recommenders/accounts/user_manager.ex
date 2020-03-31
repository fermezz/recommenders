defmodule Recommenders.Accounts.UserManager do
  import Ecto.Query, only: [where: 2]

  alias Recommenders.{Repo, Accounts}

  def create_user(attrs \\ %{}, repository \\ Repo) do
    %Accounts.User{}
    |> Accounts.User.changeset(attrs)
    |> repository.insert()
  end

  def update_user_token(%Accounts.User{} = user, token, repository \\ Repo) do
    user
    |> Accounts.User.changeset(%{token: token})
    |> repository.update()
  end

  def remove_token_from_user(token, repository \\ Repo) do
    Accounts.User
    |> where(token: ^token)
    |> repository.one()
    |> case do
      nil ->
        {:error, "Invalid user"}

      user ->
        Accounts.User.changeset(user, %{token: nil})
        |> repository.update()
    end
  end
end
