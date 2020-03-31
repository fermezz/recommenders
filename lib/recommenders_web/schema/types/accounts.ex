defmodule RecommendersWeb.Schema.Types.Accounts do
  use Absinthe.Schema.Notation

  object :user do
    field :id, :id
    field :email, :string
    field :password_hash, :string
  end

  object :session do
    field :token, :string
  end
end
