defmodule Recommenders.Accounts do
  import Ecto.Query, only: [where: 2]

  alias Recommenders.{Repo, Accounts}

  def create_user(attrs \\ %{}, repository \\ Repo) do
    %Accounts.User{}
    |> Accounts.User.changeset(attrs)
    |> repository.insert()
  end

  def delete_token(token, repository \\ Repo) do
    Accounts.User
    |> where(token: ^token)
    |> Repo.one()
    |> case do
      nil ->
        {:error, "Invalid user"}

      user ->
        Accounts.User.delete_token_changeset(user)
        |> repository.update()
    end
  end

  def store_token(%Accounts.User{} = user, token, repository \\ Repo) do
    user
    |> Accounts.User.store_token_changeset(%{token: token})
    |> repository.update()
  end
end
