# for tips, visit https://github.com/elixir-ecto/ecto/blob/v2.2.9/lib/ecto/query/api.ex
defmodule Systemstats.Mem.Meminfo.ChartQuery do
  import Ecto.Query, warn: false

  alias Systemstats.Mem.Meminfo

  def fetch_meminfo_plotdata(limit \\ 100) do
    meminfo =
      from m in Meminfo,
        order_by: [desc: :inserted_at],
        limit: ^limit,
        select: %{MemFree: m."MemFree", MemAvailable: m."MemAvailable", Buffers: m."Buffers", Cached: m."Cached", Active: m."Active", Dirty: m."Dirty", SwapFree: m."SwapFree", NFS_Unstable: m."NFS_Unstable", inserted_at: m.inserted_at}

    Systemstats.Repo.all(meminfo)
  end
end
