defmodule RecommendersWeb.Schema.Queries.Accounts do
  use Absinthe.Schema.Notation

  alias RecommendersWeb.Schema.Resolvers

  object :accounts_queries do
    @desc "Retrieve a user"
    field :user, type: :user do
      arg(:id, non_null(:string))
      resolve(&Resolvers.Accounts.find_user/3)
    end
  end
end
