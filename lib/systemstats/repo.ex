defmodule Systemstats.Repo do
  use Ecto.Repo,
    otp_app: :systemstats,
    adapter: Ecto.Adapters.Postgres
end
