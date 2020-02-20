use Mix.Config

# Configure your database
config :erss, Erss.Repo,
  username: "calle",
  password: "",
  database: "erss_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :erss, ErssWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
