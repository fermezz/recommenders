defmodule RecommendersWeb.Schema.Types.Accounts do
  use Absinthe.Schema.Notation

  object :session do
    field :token, :string
  end

  object :user do
    field :id, :id
    field :email, :string
    field :password_hash, :string
  end
end
