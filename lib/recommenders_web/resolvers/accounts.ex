defmodule RecommendersWeb.Resolvers.Accounts do
  def login(%{email: email, password: password}, _info) do
    with {:ok, user} =
           Recommenders.Accounts.AuthHelpers.login_with_email_and_password(email, password),
         {:ok, jwt, _} <- Recommenders.Guardian.encode_and_sign(user),
         {:ok, _} <- Recommenders.Accounts.store_token(user, jwt) do
      {:ok, %{token: jwt}}
    end
  end

  def create_user(args, _info) do
    Recommenders.Accounts.create_user(args)
  end
end
