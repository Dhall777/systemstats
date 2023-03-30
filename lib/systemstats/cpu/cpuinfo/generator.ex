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
    spawn_link(&clean_insert_cpu_data/0)
    schedule_work()
    {:noreply, state}
  end

  def clean_insert_cpu_data() do
    # (a) generate _ data from /proc/cpuinfo

    # Insert cleaned cpu data
    Cpu.create_cpuinfo(%{
      # create_proc_a_atom => create_proc_a_int,
    })
  end

  def schedule_work() do
    Process.send_after(self(), :work, 10_000)
  end

end
