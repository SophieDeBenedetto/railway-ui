use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :railway_ui, RailwayUiWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :railway_ui, persistence: RailwayUi.PersistenceMock

# Configure your database
config :railway_ui, RailwayUi.Repo,
  username: "postgres",
  password: "postgres",
  database: "railway_ui_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
