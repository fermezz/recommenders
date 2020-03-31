defmodule RecommendersWeb.Schema.Types.Content do
  use Absinthe.Schema.Notation

  object :recommendation do
    field :id, :id
    field :title, :string
    field :body, :string
  end
end
