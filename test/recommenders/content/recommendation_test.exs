defmodule Recommenders.Content.RecommendationTest do
  use ExUnit.Case, async: true

  test "Recommenders.Content.list_recommendations/1 returns all recommendations" do
    defmodule FakeRepo do
      def all(schema) do
        schema
      end
    end

    schema = Recommenders.Content.list_recommendations(FakeRepo)

    assert schema == Recommenders.Content.Recommendation
  end
end
