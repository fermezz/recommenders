defmodule RecommendersWeb.Schema.Resolvers.ContentTest do
  use RecommendersWeb.ConnCase

  def query_skeleton(query, query_name) do
    %{
      "operationName" => "#{query_name}",
      "query" => "query #{query_name} #{query}",
      "variables" => "{}"
    }
  end

  def mutation_skeleton(query) do
    %{
      "operationName" => "",
      "query" => "#{query}",
      "variables" => ""
    }
  end

  describe "Content Resolvers" do
    test "Retrieve recommendations' titles", %{conn: conn} do
      %Recommenders.Content.Recommendation{}
      |> Recommenders.Content.Recommendation.changeset(%{title: "hola", body: "chau"})
      |> Recommenders.Repo.insert()

      query = """
      {
        recommendations {
          title
        }
      }
      """

      response = get(conn, "/api/graphql", query_skeleton(query, "recommendations"))

      assert nil == json_response(response, 200)["data"]["recommendations"]
      assert "Not authorized" == List.first(json_response(response, 200)["errors"])["message"]
    end
  end
end
