defmodule Recommenders.Content.RecommendationManagerTest do
  use ExUnit.Case, async: true

  test "Recommenders.Content.RecommendationManager.list_recommendations/1 returns all recommendations" do
    defmodule FakeRepo do
      def all(query) do
        query
      end
    end

    query = Recommenders.Content.RecommendationManager.list_recommendations(FakeRepo)

    assert query == Recommenders.Content.Recommendation
  end

  test "Recommenders.Content.RecommendationManager.list_recommendations_for_user/2 returns all recommendations that are targeted to a user" do
    defmodule FakeRepoForUser do
      def all(query) do
        query
      end
    end

    result =
      Recommenders.Content.RecommendationManager.list_recommendations_for_user(1, FakeRepoForUser)

    assert Ecto.Adapters.SQL.to_sql(:all, Recommenders.Repo, result) ==
             {"SELECT r0.\"id\", r0.\"title\", r0.\"body\", r0.\"to\", r0.\"inserted_at\", r0.\"updated_at\" FROM \"recommendations\" AS r0 WHERE (r0.\"to\" = $1)",
              [1]}
  end
end
