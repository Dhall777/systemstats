defmodule Systemstats.Datastreams.Cpustream.Generator do
  use GenServer

  import Ecto.Query, warn: false

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    spawn_link(&clean_insert_cpufreq_data/0)
    schedule_work()
    {:noreply, state}
  end

  def clean_insert_cpufreq_data() do
    # generate & handle incoming CPU info from /proc/cpuinfo -> to be stored/queried by Ecto to generate live plots, per 10 seconds
    dd_proc = System.cmd("cat", ["/proc/cpuinfo"]) |> Kernel.elem(0)
    proc_dd = String.slice(dd_proc, 0..12)
    proc_dd_clean = String.replace(proc_dd, "\t:", "")
    # IO.inspect(proc_dd_clean)
    create_proc_atom = String.slice(proc_dd_clean, 0..8) |> String.to_atom()
    create_proc_int = String.slice(proc_dd_clean, 10..11) |> String.to_integer()

    dd_freq = String.slice(dd_proc, 155..173)
    freq_dd = String.replace(dd_freq, "\t\t:", "")
    freq_dd_clean = String.replace(freq_dd, "cpu MHz", "cpu_MHz")
    # IO.inspect(freq_dd_clean)
    create_freq_atom = String.slice(freq_dd_clean, 0..6) |> String.to_atom()
    create_freq_float = String.slice(freq_dd_clean, 8..16) |> String.to_float()

    # Insert cleaned data -> this function is pulled from our context, alias it at some point...
    Systemstats.Datastreams.create_cpustream(%{
      create_proc_atom => create_proc_int,
      create_freq_atom => create_freq_float
    })

    # Debug code samples below
    # debug = System.cmd("cat", ["/proc/cpuinfo"]) |> Kernel.elem(0)
    # IO.inspect(debug)
  end

  def schedule_work() do
    Process.send_after(self(), :work, 10_000)
  end

end
