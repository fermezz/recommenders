defmodule RecommendersWeb.Schema.Queries.Content do
  use Absinthe.Schema.Notation

  alias RecommendersWeb.Schema.Resolvers

  object :content_queries do
    @desc "Get all recommendations"
    field :recommendations, list_of(:recommendation) do
      resolve(&Resolvers.Content.list_recommendations/3)
    end
  end
end
