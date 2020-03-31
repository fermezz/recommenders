defmodule RecommendersWeb.Schema.Resolvers.Accounts do
  def login(%{email: email, password: password}, _info) do
    with {:ok, user} =
           Recommenders.Accounts.AuthHelpers.login_with_email_and_password(email, password),
         {:ok, jwt, _} <- Recommenders.Guardian.encode_and_sign(user),
         {:ok, _} <- Recommenders.Accounts.UserManager.update_user_token(user, jwt) do
      {:ok, %{token: jwt}}
    end
  end

  def logout(%{token: token}, _info) do
    Recommenders.Accounts.UserManager.remove_token_from_user(token)
  end

  def signup(args, _info) do
    Recommenders.Accounts.UserManager.create_user(args)
  end
end
