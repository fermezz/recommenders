defmodule RecommendersWeb.Schema.Mutations.Accounts do
  use Absinthe.Schema.Notation

  alias RecommendersWeb.Schema.Resolvers

  object :accounts_mutations do
    @desc "Create a user"
    field :create_user, type: :user do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))

      resolve(&Resolvers.Accounts.create_user/2)
    end
  end
end
