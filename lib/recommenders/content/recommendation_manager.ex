defmodule Recommenders.Content.RecommendationManager do
  import Ecto.Query, only: [from: 2]

  alias Recommenders.{Repo, Content}

  def list_recommendations(repository \\ Repo) do
    repository.all(Content.Recommendation)
  end

  def list_recommendations_for_user(user_id, repository \\ Repo) do
    repository.all(from r in Content.Recommendation, where: r.to == ^user_id)
  end
end
