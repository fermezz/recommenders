defmodule RecommendersWeb.Schema.Types.Accounts do
  use Absinthe.Schema.Notation

  alias RecommendersWeb.Schema.Resolvers

  object :session do
    field :token, :string
  end

  object :user do
    field :id, :id
    field :email, :string
    field :password_hash, :string

    # Recommendations
    field :has_been_recommended, list_of(:recommendation) do
      resolve(&Resolvers.Content.list_recommendations/3)
    end
  end
end
