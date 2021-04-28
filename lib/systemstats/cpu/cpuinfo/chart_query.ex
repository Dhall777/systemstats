defmodule Systemstats.Cpu.Cpuinfo.ChartQuery do
  import Ecto.Query, warn: false

  alias Systemstats.Cpu
  alias Systemstats.Cpu.Cpuinfo

  def fetch_cpuinfo_plotdata({processor}, limit \\ 100) do
    cpuinfo =
      from c in Cpuinfo,
        where: [processor: ^processor],
        order_by: [desc: :inserted_at],
        limit: ^limit,
        select: %{processor: c.processor, cpu_MHz: c.cpu_MHz, inserted_at: c.inserted_at}

    Systemstats.ShackletonRepo.all(cpuinfo)
  end
end
