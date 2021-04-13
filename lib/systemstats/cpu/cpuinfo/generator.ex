defmodule Systemstats.Cpu.Cpuinfo.Generator do
  alias Systemstats.Cpu

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
    a_proc = System.cmd("cat", ["/proc/cpuinfo"]) |> Kernel.elem(0)
    proc_a = String.slice(a_proc, 0..12)
    proc_a_clean = String.replace(proc_a, "\t:", "")
    # IO.inspect(proc_a_clean)
    create_proc_a_atom = String.slice(proc_a_clean, 0..8) |> String.to_atom()
    create_proc_a_int = String.slice(proc_a_clean, 10..11) |> String.to_integer()

    a_freq = String.slice(a_proc, 155..173)
    freq_a = String.replace(a_freq, "\t\t:", "")
    freq_a_clean = String.replace(freq_a, "cpu MHz", "cpu_MHz")
    # IO.inspect(freq_a_clean)
    create_freq_a_atom = String.slice(freq_a_clean, 0..6) |> String.to_atom()
    create_freq_a_float = String.slice(freq_a_clean, 8..16) |> String.to_float()

    # Insert cleaned data -> this function is pulled from our context, alias it at some point...
    Cpu.create_cpuinfo(%{
      create_proc_a_atom => create_proc_a_int,
      create_freq_a_atom => create_freq_a_float
    })

    # Debug code samples below
    # debug = System.cmd("cat", ["/proc/cpuinfo"]) |> Kernel.elem(0)
    # IO.inspect(debug)
  end

  def schedule_work() do
    Process.send_after(self(), :work, 10_000)
  end

end
