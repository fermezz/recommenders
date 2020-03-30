defmodule Recommenders.Accounts do
  alias Recommenders.{Repo, Accounts}

  def create_user(attrs \\ %{}, repository \\ Repo) do
    %Accounts.User{}
    |> Accounts.User.changeset(attrs)
    |> repository.insert()
  end

  def store_token(%Accounts.User{} = user, token, repository \\ Repo) do
    user
    |> Accounts.User.store_token_changeset(%{token: token})
    |> repository.update()
  end
end
