defmodule RecommendersWeb.Schema.Resolvers.Content do
  def list_recommendations(_parent, _args, %{context: %{current_user: current_user}}) do
    {:ok, Recommenders.Content.list_recommendations()}
  end

  def list_recommendations(_parent, _args, _info) do
    {:error, "Not authorized"}
  end
end
