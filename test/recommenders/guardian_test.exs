defmodule Recommenders.GuardianTest do
  use RecommendersWeb.ConnCase, async: true

  alias Recommenders.Guardian

  describe "Guardian module" do
    test "Recommenders.Guardian.subject_for_token/2 returns the id of a given user" do
      user = %Recommenders.Accounts.User{id: 1, email: "user@test.com@", password: "pepehongo"}
      assert {:ok, "1"} == Guardian.subject_for_token(user, %{})
    end

    test "Recommenders.Guardian.resource_from_claims/1 return the user stored in claims" do
      assert {:ok, %Recommenders.Accounts.User{} = user} =
               Recommenders.Accounts.UserManager.create_user(%{
                 email: "user@test.com",
                 password: "pepehongo"
               })

      # Returns the exact same user but without any passwords set.
      assert {:ok, Map.put(user, :password, nil)} ==
               Guardian.resource_from_claims(%{"sub" => user.id})
    end
  end
end
