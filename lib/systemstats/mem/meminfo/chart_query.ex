defmodule Systemstats.Mem.Meminfo.ChartQuery do
  import Ecto.Query, warn: false

  alias Systemstats.Mem.Meminfo

  def fetch_meminfo_plotdata(limit \\ 100) do
    meminfo =
      from m in Meminfo,
        order_by: [desc: :inserted_at],
        limit: ^limit,
        select: %{MemAvailable: m."MemAvailable", Buffers: m."Buffers", Cached: m."Cached", Active: m."Active", SwapFree: m."SwapFree", PageTables: m."PageTables", inserted_at: m.inserted_at}

    Systemstats.Repo.all(meminfo)
  end
end
