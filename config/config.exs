# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

config :erss,
  ecto_repos: [Erss.Repo]

# Configures the endpoint
config :erss, ErssWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "GIGKaJqY9PoDvvaMpz+h51D7Ofy6slzQQcEw/4LI5nUqEZAiRQfVNiSi/YAs1BNR",
  render_errors: [view: ErssWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Erss.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :erss, Erss.Scheduler,
  jobs: [
    {"*/15 * * * *", {Erss, :get_and_store_feed, []}}
  ]

config :erss, :pow,
  user: Erss.Users.User,
  repo: Erss.Repo,
  extensions: [PowPersistentSession],
  controller_callbacks: Pow.Extension.Phoenix.ControllerCallbacks

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
