defmodule RecommendersWeb.Schema.Resolvers.AccountsTest do
  use RecommendersWeb.ConnCase

  def mutation_skeleton(query) do
    %{
      "operationName" => "",
      "query" => "#{query}",
      "variables" => ""
    }
  end

  describe "Accounts Resolvers" do
    test "RecommendersWeb.Schema.Resolvers.Account.signup/2 should be successful for correct email and password",
         %{conn: conn} do
      query = ~S/
      mutation {
        signup(email: "user@test.com", password: "valid_password") {
          id
          email
        }
      }
      /

      response = post(conn, "/api/graphql", mutation_skeleton(query))

      %{"email" => "user@test.com", "id" => "" <> _} =
        json_response(response, 200)["data"]["signup"]
    end

    test "RecommendersWeb.Schema.Resolvers.Accounts.login/2 should be successful for correct email and password",
         %{conn: conn} do
      %Recommenders.Accounts.User{}
      |> Recommenders.Accounts.User.changeset(%{
        email: "test@user.com",
        password: "password",
        token: nil
      })
      |> Recommenders.Repo.insert()

      query = ~s/
      mutation {
        login(email: "test@user.com", password: "password") {
          token
        }
      }
      /

      response = post(conn, "/api/graphql", mutation_skeleton(query))

      assert %{"token" => "eyJ" <> _} = json_response(response, 200)["data"]["login"]
    end

    test "RecommendersWeb.Schema.Resolvers.Accounts.login/2 should yield an error if the user doesn't exist",
         %{conn: conn} do
      query = ~s/
      mutation {
        login(email: "test@user.com", password: "password") {
          token
        }
      }
      /

      response = post(conn, "/api/graphql", mutation_skeleton(query))

      assert nil == json_response(response, 200)["data"]["login"]
      assert "User not found" == List.first(json_response(response, 200)["errors"])["message"]
    end

    test "RecommendersWeb.Schema.Resolvers.Accounts.logout/2 should be successful for correct token",
         %{conn: conn} do
      {:ok, user} =
        %Recommenders.Accounts.User{}
        |> Recommenders.Accounts.User.changeset(%{email: "test@user.com", password: "password"})
        |> Recommenders.Repo.insert()

      {:ok, jwt, _} = Recommenders.Guardian.encode_and_sign(user)
      Recommenders.Accounts.UserManager.update_user(user, %{token: jwt})

      query = ~s/
      mutation {
        logout(token: "#{jwt}") {
          token
        }
      }
      /

      response = post(conn, "/api/graphql", mutation_skeleton(query))

      assert %{"token" => nil} == json_response(response, 200)["data"]["logout"]
    end
  end
end
