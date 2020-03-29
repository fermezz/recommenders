defmodule Recommenders.Repo.Migrations.CreateRecommendations do
  use Ecto.Migration

  def change do
    create table(:recommendations) do
      add :title, :string
      add :body, :string
      timestamps()
    end
  end
end
