defmodule Recommenders.Accounts.UserTest do
  use ExUnit.Case, async: true

  alias Recommenders.Accounts.User

  test "Recommenders.Accounts.User.changeset/2 gets populated correctly if every field is correct" do
    changeset = User.changeset(%User{}, %{email: "user@test.com", password: "password"})

    # We can just pattern match the result instead of asserting each of them.
    # Given that we won't know the password_hash generated, we can pattern match
    # for it being a string.
    %{email: "user@test.com", password: "password", password_hash: "" <> _} = changeset.changes
    assert changeset.valid?
  end

  test "Recommenders.Accounts.User.changeset/2 rejects validation for short password" do
    changeset = User.changeset(%User{}, %{email: "user@test.com", password: "pass"})

    # Password should be +5 chars long
    refute changeset.valid?
  end

  test "Recommenders.Accounts.User.changeset/2 rejects validation for missing email" do
    changeset = User.changeset(%User{}, %{password: "password"})

    # Both email and password should be present
    refute changeset.valid?
  end

  test "Recommenders.Accounts.User.changeset/2 only updates specific fields if struct is not empty" do
    changeset =
      User.changeset(%User{email: "user@test.com", password: "password"}, %{
        password: "another_password"
      })

    assert changeset.valid?
    assert %{password: "another_password"} == changeset.changes
  end
end
