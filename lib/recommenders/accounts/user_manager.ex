defmodule Recommenders.Accounts.UserManager do
  import Comeonin.Bcrypt, only: [checkpw: 2]
  import Ecto.Query, only: [where: 2]

  alias Recommenders.{Repo, Accounts}

  def get_user!(user_id, repository \\ Repo) do
    repository.get!(Accounts.User, user_id)
  end

  def signup(%{email: email, password: password} = attrs, repository \\ Repo) do
    create_user(attrs, repository)
    |> case do
      {:ok, _user} -> authenticate_user(email, password, repository)
      {:error, %{errors: errors}} -> {:error, errors |> Enum.map(&handle_errors(&1))}
    end
  end

  defp handle_errors({key, {message, _}}) do
    "There was an error with the \"#{key}\" field: #{message}"
  end

  def create_user(attrs, repository \\ Repo) do
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
        with {:ok, jwt, _} <- Recommenders.Guardian.encode_and_sign(user) do
          update_user(user, %{token: jwt}, repository)
        end

      user ->
        {:error, "Incorrect login credentials"}

      true ->
        {:error, "User not found"}
    end
  end
end
