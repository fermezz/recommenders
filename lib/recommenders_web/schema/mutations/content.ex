defmodule RecommendersWeb.Schema.Mutations.Content do
  use Absinthe.Schema.Notation

  alias RecommendersWeb.Schema.Resolvers

  object :content_mutations do
    @desc "Recommend something to a user"
    field :recommendation, type: :recommendation do
      arg(:title, non_null(:string))
      arg(:to, non_null(:string))
      arg(:body, :string)

      resolve(&Resolvers.Content.recommend/2)
    end
  end
end
