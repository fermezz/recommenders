defmodule Recommenders.Content.Recommendation do
  use Ecto.Schema
  import Ecto.Changeset

  alias Recommenders.{Content}

  schema "recommendations" do
    field :title, :string
    field :body, :string
    field :to, :integer
    timestamps()
  end

  @doc false
  def changeset(%Content.Recommendation{} = recommendation, attrs) do
    recommendation
    |> cast(attrs, [:title, :body, :to])
    |> validate_required([:title, :body, :to])
  end
end
