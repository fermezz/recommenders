defmodule RecommendersWeb.Schema.Resolvers.Accounts do
  alias Recommenders.Accounts.UserManager

  def find_user(_parent, %{id: user_id}, _info) do
    {:ok, UserManager.get_user!(user_id)}
  end

  def login(%{email: email, password: password}, _info) do
    case UserManager.authenticate_user(email, password) do
      {:ok, user} -> {:ok, user}
      error -> error
    end
  end

  def logout(%{token: token}, _info) do
    Recommenders.Accounts.UserManager.remove_token_from_user(token)
  end

  def signup(args, _info) do
    Recommenders.Accounts.UserManager.signup(args)
  end
end
