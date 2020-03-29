defmodule Recommenders.Content do
  import Ecto.Query

  alias Recommenders.{Repo, Content}

  def list_recommendations do
    Repo.all(Content.Recommendation)
  end
end
