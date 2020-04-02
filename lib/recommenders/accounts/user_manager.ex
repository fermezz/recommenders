defmodule Recommenders.Accounts.UserManager do
  import Comeonin.Bcrypt, only: [checkpw: 2]
  import Ecto.Query, only: [where: 2]

  alias Recommenders.{Repo, Accounts}

  def get_user!(user_id, repository \\ Repo) do
    repository.get!(Accounts.User, user_id)
  end

  def create_user(attrs \\ %{}, repository \\ Repo) do
    %Accounts.User{}
    |> Accounts.User.changeset(attrs)
    |> repository.insert()
  end

  def update_user(%Accounts.User{} = user, changes, repository \\ Repo) do
    user
    |> Accounts.User.changeset(changes)
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

  def authenticate_user(email, password, repository \\ Repo) do
    user = repository.get_by(Accounts.User, email: String.downcase(email))

    cond do
      user && checkpw(password, user.password_hash) ->
        {:ok, user}

      user ->
        {:error, "Incorrect login credentials"}

      true ->
        {:error, "User not found"}
    end
  end
end
