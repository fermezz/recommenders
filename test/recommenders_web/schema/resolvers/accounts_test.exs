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
    test "Signup a user", %{conn: conn} do
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

    test "Login a user", %{conn: conn} do
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

      %{"token" => "eyJ" <> _} = json_response(response, 200)["data"]["login"]
    end

    test "Logout a user", %{conn: conn} do
      {:ok, user} =
        %Recommenders.Accounts.User{}
        |> Recommenders.Accounts.User.changeset(%{email: "test@user.com", password: "password"})
        |> Recommenders.Repo.insert()

      {:ok, jwt, _} = Recommenders.Guardian.encode_and_sign(user)
      Recommenders.Accounts.UserManager.update_user_token(user, jwt)

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
