defmodule Recommenders.Repo.Migrations.AddFromUserAndToUserToRecommendations do
  use Ecto.Migration

  def change do
    alter table(:recommendations) do
      add :from, references(:users)
      add :to, references(:users)
    end
  end
end
