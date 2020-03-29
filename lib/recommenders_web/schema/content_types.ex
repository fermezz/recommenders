defmodule RecommendersWeb.Schema.ContentTypes do
  use Absinthe.Schema.Notation

  object :recommendation do
    field :id, :id
    field :title, :string
    field :body, :string
  end

  object :user do
    field :id, :id
    field :name, :string
    field :password_hash, :string
  end
end
