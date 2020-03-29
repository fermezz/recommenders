defmodule Recommenders.Content do
  alias Recommenders.{Repo, Content}

  def list_recommendations(repository \\ Repo) do
    repository.all(Content.Recommendation)
  end
end
