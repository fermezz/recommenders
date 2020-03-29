defmodule Recommenders.Accounts.UserTest do
  use ExUnit.Case

  test "Recommenders.Accounts.create_user/2" do
    defmodule FakeRepo do
      def insert(changeset) do
        changeset
      end
    end

    attrs = %{
      :email => "user@test.com",
      :password => "password"
    }

    changeset = Recommenders.Accounts.create_user(attrs, FakeRepo)

    # The changeset is arriving correctly to the Repo.
    assert Map.get(attrs, :email) == Map.get(changeset.changes, :email)
    assert Map.get(attrs, :password) == Map.get(changeset.changes, :password)
  end
end
