defmodule RecommendersWeb.Schema.Mutations.Accounts do
  use Absinthe.Schema.Notation

  alias RecommendersWeb.Schema.Resolvers

  object :accounts_mutations do
    @desc "Signup a user"
    field :signup, type: :user do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))

      resolve(&Resolvers.Accounts.signup/2)
    end

    @desc "Logout a user"
    field :logout, type: :session do
      arg(:token, non_null(:string))

      resolve(&Resolvers.Accounts.logout/2)
    end

    @desc "Login a user with email and password"
    field :login, type: :session do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))

      resolve(&Resolvers.Accounts.login/2)
    end
  end
end
