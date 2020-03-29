defmodule Recommenders.Accounts do
  alias Recommenders.{Repo, Accounts}

  def create_user(attrs \\ %{}, repository \\ Repo) do
    %Accounts.User{}
    |> Accounts.User.changeset(attrs)
    |> repository.insert()
  end
end
