defmodule Systemstats.Datastreams.Cpustream.ChartQuery do
  import Ecto.Query, warn: false

  alias Systemstats.Datastreams
  alias Systemstats.Datastreams.Cpustream

  def fetch_cpustream_plotdata({processor}, limit \\ 100) do
    cpustream =
      from c in Cpustream,
        where: [processor: ^processor],
        order_by: [desc: :inserted_at],
        limit: ^limit,
        select: %{processor: c.processor, cpu_MHz: c.cpu_MHz, inserted_at: c.inserted_at}

    Systemstats.Repo.all(cpustream)
  end
end
