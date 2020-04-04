defmodule RecommendersWeb.Schema.Resolvers.Content do
  def list_recommendations(%Recommenders.Accounts.User{} = user, _args, %{
        context: %{current_user: current_user}
      }) do
    case current_user.id == user.id do
      true ->
        {:ok, Recommenders.Content.RecommendationManager.list_recommendations_for_user(user.id)}

      _ ->
        {:error, "Not authroized"}
    end
  end

  def list_recommendations(_parent, _args, %{context: %{current_user: _current_user}}) do
    {:ok, Recommenders.Content.RecommendationManager.list_recommendations()}
  end

  def list_recommendations(_parent, _args, _info) do
    {:error, "Not authorized"}
  end

  def recommend(args, %{context: %{current_user: current_user}}) do
    Recommenders.Content.RecommendationManager.recommends(current_user, args)
  end

  def recommend(_args, _info) do
    {:error, "Not authorized"}
  end
end
