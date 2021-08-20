# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :jnapi,
  namespace: JNApi,
  ecto_repos: [JNApi.Repo]

# Configures the endpoint
config :jnapi, JNApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "z9TbkAINVlxFTflvppyXwc4VXC27qRSnljGfaw3K8l6S+lnBQ8oLSc4NMi11diCo",
  render_errors: [view: JNApiWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: JNApi.PubSub,
  live_view: [signing_salt: "DpnjPaQl"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :jnapi, :pow,
  user: JNApi.Users.User,
  repo: JNApi.Repo

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
