defmodule Recommenders.Schema do
  use Absinthe.Schema
  import_types(RecommendersWeb.Schema.ContentTypes)

  alias RecommendersWeb.Resolvers

  query do
    @desc "Get all recommendations"
    field :recommendations, list_of(:recommendation) do
      resolve(&Resolvers.Content.list_recommendations/3)
    end
  end
end
