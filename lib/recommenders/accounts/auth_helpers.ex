defmodule Recommenders.Accounts.AuthHelpers do
  @moduledoc false

  import Comeonin.Bcrypt, only: [checkpw: 2]
  alias Recommenders.Repo
  alias Recommenders.Accounts.User

  def login_with_email_and_password(email, given_password, repository \\ Repo) do
    user = repository.get_by(User, email: String.downcase(email))

    cond do
      user && checkpw(given_password, user.password_hash) ->
        {:ok, user}

      user ->
        {:error, "Incorrect login credentials"}

      true ->
        {:error, :"User not found"}
    end
  end
end
