defmodule Recommenders.Repo do
  use Ecto.Repo,
    otp_app: :recommenders,
    adapter: Ecto.Adapters.Postgres
end
