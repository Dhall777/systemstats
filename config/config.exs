# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :systemstats,
  ecto_repos:
    [Systemstats.ShackletonRepo]
    [Systemstats.BattutaRepo]
    [Systemstats.KupeRepo]
    [Systemstats.TabeiRepo]

# Configures the endpoint
config :systemstats, SystemstatsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "V6IYx12w5kTdcUMVN7JNKZlGpIdThADs5t3kj5c6cfHsBVRosgKl6cUe3pUZ86tC",
  render_errors: [view: SystemstatsWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Systemstats.PubSub,
  live_view: [signing_salt: "Nj8cvley"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
