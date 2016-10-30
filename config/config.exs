# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :memo_web,
  ecto_repos: [MemoWeb.Repo]

# Configures the endpoint
config :memo_web, MemoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "a/K84K1gZVeFyU52zr3PQeW13Oe79vq5ROVQ+TVOcTkIzFF4weIbeIyEU9VrFqJC",
  render_errors: [view: MemoWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: MemoWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Guardian config
config :guardian, Guardian,
  issuer: "MemoWeb",
  ttl: { 30, :days },
  secret_key: System.get_env("GUARDIAN_SECRET") || "j4luxitBg0K/89hqMW5YAAU5lQti2c7m57spmAykhTisVzav2LV05toCG4QFZuJo",
  serializer: MemoWeb.GuardianSerializer

# db interaction modules
config :memo_web, MemoWeb, user_storage: MemoWeb.UserStorage
config :memo_web, MemoWeb, memo_storage: MemoWeb.MemoStorage

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
