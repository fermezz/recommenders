defmodule Recommenders.Accounts.UserManagerTest do
  use ExUnit.Case, async: true

  test "Recommenders.Accounts.UserManager.get_user!/2" do
    defmodule FakeRepoGetUser do
      def get!(_user, user_id) do
        user_id
      end
    end

    user_id = Recommenders.Accounts.UserManager.get_user!(1, FakeRepoGetUser)

    assert 1 == user_id
  end

  test "Recommenders.Accounts.UserManager.signup/2 works great for correct user and email" do
    defmodule FakeRepoCreateUser do
      def insert(changeset) do
        {:ok, changeset}
      end

      def get_by(_schema, email) do
        %Recommenders.Accounts.User{
          id: 1,
          email: email,
          password_hash: Comeonin.Bcrypt.hashpwsalt("password")
        }
      end

      def update(changeset) do
        {:ok, changeset}
      end
    end

    attrs = %{
      :email => "user@test.com",
      :password => "password"
    }

    {:ok, changeset} = Recommenders.Accounts.UserManager.signup(attrs, FakeRepoCreateUser)

    assert %{token: _} = changeset.changes
  end

  test "Recommenders.Accounts.UserManager.signup/2 returns error for short password" do
    defmodule FakeRepoCreateIncorrectUser do
      def insert(changeset) do
        {:error, changeset}
      end

      def get_by(_schema, email) do
        %{id: 1, email: email, password_hash: Comeonin.Bcrypt.hashpwsalt("password")}
      end
    end

    attrs = %{
      :email => "user@test.com",
      :password => "pass"
    }

    {:error, errors} =
      Recommenders.Accounts.UserManager.signup(attrs, FakeRepoCreateIncorrectUser)

    # The changeset is arriving correctly to the Repo.
    assert [
             "There was an error with the \"password\" field: should be at least %{count} character(s)"
           ] == errors
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

  test "Recommenders.Accounts.UserManager.update_user/3" do
    defmodule FakeRepoUpdateUser do
      def update(changeset) do
        changeset
      end
    end

    changeset =
      Recommenders.Accounts.UserManager.update_user(
        %Recommenders.Accounts.User{id: 1},
        %{token: "my_token"},
        FakeRepoUpdateUser
      )

    assert %{token: "my_token"} == changeset.changes
  end

  test "Recommenders.Accounts.UserManager.authenticate_user/3 is successful with correct email and password" do
    defmodule FakeRepoAuthenticateUser do
      def get_by(_user_schema, email) do
        password_hash = Comeonin.Bcrypt.hashpwsalt("pepehongo")
        %Recommenders.Accounts.User{email: email[:email], password_hash: password_hash}
      end

      def update(changeset) do
        {:ok, changeset}
      end
    end

    assert {:ok, changeset} =
             Recommenders.Accounts.UserManager.authenticate_user(
               "user@test.com",
               "pepehongo",
               FakeRepoAuthenticateUser
             )

    assert %{token: _} = changeset.changes
  end

  test "Recommenders.Accounts.UserManager.authenticate_user/3 error with incorrect credentials" do
    defmodule FakeRepoAuthenticateUserIncorrect do
      def get_by(_user_schema, email) do
        password_hash = Comeonin.Bcrypt.hashpwsalt("pepehongo")
        %Recommenders.Accounts.User{email: email[:email], password_hash: password_hash}
      end
    end

    assert {:error, "Incorrect login credentials"} =
             Recommenders.Accounts.UserManager.authenticate_user(
               "user@test.com",
               "wrong_password",
               FakeRepoAuthenticateUserIncorrect
             )
  end

  test "Recommenders.Accounts.UserManager.authenticate_user/3 error when user is not found" do
    defmodule FakeRepoAuthenticateUserNotFound do
      def get_by(_user_schema, _email) do
        nil
      end
    end

    assert {:error, "User not found"} =
             Recommenders.Accounts.UserManager.authenticate_user(
               "user@test.com",
               "pepehongo",
               FakeRepoAuthenticateUserNotFound
             )
  end
end
