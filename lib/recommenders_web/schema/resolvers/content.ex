defmodule RecommendersWeb.Schema.Resolvers.Content do
  def list_recommendations(%Recommenders.Accounts.User{} = user, _args, %{
        context: %{current_user: _current_user}
      }) do
    {:ok, Recommenders.Content.RecommendationManager.list_recommendations_for_user(user.id)}
  end

  def list_recommendations(_parent, _args, %{context: %{current_user: _current_user}}) do
    {:error, Recommenders.Content.RecommendationManager.list_recommendations()}
  end

  def list_recommendations(_parent, _args, _info) do
    {:error, "Not authorized"}
  end
end
