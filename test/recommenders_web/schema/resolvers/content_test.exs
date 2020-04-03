defmodule RecommendersWeb.Schema.Resolvers.ContentTest do
  use RecommendersWeb.ConnCase

  import Plug.Conn, only: [put_private: 3]

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

    test "Retrieve recommendations' titles for user", %{conn: conn} do
      {:ok, user} =
        %Recommenders.Accounts.User{}
        |> Recommenders.Accounts.User.changeset(%{
          email: "test@user.com",
          password: "password",
          token: nil
        })
        |> Recommenders.Repo.insert()

      {:ok, jwt} = RecommendersWeb.Schema.Resolvers.Accounts.login(user, %{})

      %Recommenders.Content.Recommendation{}
      |> Recommenders.Content.Recommendation.changeset(%{
        title: "My title",
        body: "A body",
        to: user.id
      })
      |> Recommenders.Repo.insert()

      query = """
      {
        user(id: "#{user.id}") {
          has_been_recommended {
            title
          }
        }
      }
      """

      context = %{context: %{current_user: user, token: jwt}}

      response =
        get(
          conn |> put_private(:absinthe, context),
          "/api/graphql",
          query_skeleton(query, "recommendations")
        )

      assert [%{"title" => "My title"}] ==
               json_response(response, 200)["data"]["user"]["has_been_recommended"]
    end
  end
end
