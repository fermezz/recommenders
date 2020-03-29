defmodule RecommendersWeb.Schema do
  use Absinthe.Schema
  import_types(RecommendersWeb.Schema.ContentTypes)

  alias RecommendersWeb.Resolvers

  query do
    @desc "Get all recommendations"
    field :recommendations, list_of(:recommendation) do
      resolve(&Resolvers.Content.list_recommendations/3)
    end
  end

  mutation do
    @desc "Create a user"
    field :create_user, type: :user do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))

      resolve(&Resolvers.Accounts.create_user/2)
    end
  end
end
