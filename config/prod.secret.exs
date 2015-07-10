use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system. Here we do that by
# using environment variables
config :o_auth2_example, OAuth2Example.Endpoint,
  secret_key_base: System.get_env("SECRET_KEY_BASE")

# Configure your database
config :o_auth2_example, OAuth2Example.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL") ||
    "ecto://postgres:postgres@localhost/o_auth2_example_prod,
  size: 20 # The amount of database connections in the pool
