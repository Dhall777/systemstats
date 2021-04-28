defmodule Systemstats.ShackletonRepo do
  use Ecto.Repo,
    otp_app: :systemstats,
    adapter: Ecto.Adapters.Postgres,
    database: "systemstats_shackleton"
end

defmodule Systemstats.TabeiRepo do
  use Ecto.Repo,
    otp_app: :systemstats,
    adapter: Ecto.Adapters.Postgres,
    database: "systemstats_tabei"
end

defmodule Systemstats.BattutaRepo do
  use Ecto.Repo,
    otp_app: :systemstats,
    adapter: Ecto.Adapters.Postgres,
    database: "systemstats_battuta"
end

defmodule Systemstats.KupeRepo do
  use Ecto.Repo,
    otp_app: :systemstats,
    adapter: Ecto.Adapters.Postgres,
    database: "systemstats_kupe"
end
