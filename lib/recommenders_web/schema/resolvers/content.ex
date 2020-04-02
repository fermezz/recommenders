defmodule RecommendersWeb.Schema.Resolvers.Content do
  def list_recommendations(_parent, _args, _info) do
    {:ok, Recommenders.Content.list_recommendations()}
  end
end