defmodule Recommenders.Content.RecommendationManager do
  import Ecto.Query, only: [from: 2]

  alias Recommenders.{Repo, Content}

  def list_recommendations(repository \\ Repo) do
    repository.all(Content.Recommendation)
  end

  def list_recommendations_for_user(user_id, repository \\ Repo) do
    repository.all(from r in Content.Recommendation, where: r.to == ^user_id)
  end

  def recommends(user, attrs, repository \\ Repo) do
    %Content.Recommendation{}
    |> Content.Recommendation.changeset(attrs |> Map.put(:from, user.id))
    |> repository.insert()
    |> case do
      {:ok, recommendation} -> {:ok, recommendation}
      {:error, %{errors: errors}} -> {:error, errors |> Enum.map(&handle_errors(&1))}
    end
  end

  defp handle_errors({key, {message, _}}) do
    "There was an error with the \"#{key}\" field: #{message}"
  end
end
