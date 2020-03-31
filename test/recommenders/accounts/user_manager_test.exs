defmodule Recommenders.Accounts.UserManagerTest do
  use ExUnit.Case, async: true

  test "Recommenders.Accounts.UserManager.create_user/2" do
    defmodule FakeRepoCreateUser do
      def insert(changeset) do
        changeset
      end
    end

    attrs = %{
      :email => "user@test.com",
      :password => "password"
    }

    changeset = Recommenders.Accounts.UserManager.create_user(attrs, FakeRepoCreateUser)

    # The changeset is arriving correctly to the Repo.
    assert Map.get(attrs, :email) == Map.get(changeset.changes, :email)
    assert Map.get(attrs, :password) == Map.get(changeset.changes, :password)
  end

  test "Recommenders.Accounts.UserManager.remove_token_from_user/3 sets token correctly to be an empty string" do
    defmodule FakeRepoRemoveToken do
      def one(user_id) do
        %Recommenders.Accounts.User{id: user_id, token: "my_token"}
      end

      def update(changeset) do
        changeset
      end
    end

    changeset = Recommenders.Accounts.UserManager.remove_token_from_user(1, FakeRepoRemoveToken)

    assert %{token: nil} == changeset.changes
  end

  test "Recommenders.Accounts.UserManager.remove_token_from_user/3 returns error if no user exists with the provided id" do
    defmodule FakeRepoNoUser do
      def one(_user_id) do
        nil
      end
    end

    result = Recommenders.Accounts.UserManager.remove_token_from_user(1, FakeRepoNoUser)

    assert {:error, "Invalid user"} == result
  end

  test "Recommenders.Accounts.UserManager.update_user_token/3" do
    defmodule FakeRepoUpdateUser do
      def update(changeset) do
        changeset
      end
    end

    changeset =
      Recommenders.Accounts.UserManager.update_user_token(
        %Recommenders.Accounts.User{id: 1},
        "my_token",
        FakeRepoUpdateUser
      )

    assert %{token: "my_token"} == changeset.changes
  end
end
