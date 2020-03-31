defmodule Recommenders.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Recommenders.{Accounts}

  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :token, :string
    timestamps()
  end

  @doc false
  def changeset(%Accounts.User{} = user, attrs) when user == %Accounts.User{} do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> validate_length(:password, min: 5, max: 20)
    |> unique_constraint(:email, downcase: true)
    |> put_password_hash()
  end

  def changeset(%Accounts.User{} = user, attrs), do: user |> Ecto.Changeset.change(attrs)

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))

      _ ->
        changeset
    end
  end
end
