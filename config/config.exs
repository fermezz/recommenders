# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :recommenders,
  ecto_repos: [Recommenders.Repo]

# Configures the endpoint
config :recommenders, RecommendersWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ml9Ndi4Y9VR6R+eGVvKbsid3DK3f6cbQMA1v259rtdIDvhjdfD6M26nxKqvGCHO6",
  render_errors: [view: RecommendersWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Recommenders.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "tiii/quV"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"