defmodule Systemstats.Mem.Meminfo.Generator do
  alias Systemstats.Mem

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
    spawn_link(&clean_insert_memory_data/0)
    schedule_work()
    {:noreply, state}
  end

  def clean_insert_memory_data() do
    # (a) generate & insert incoming free memory info from /proc/meminfo
    a_mem = System.cmd("cat", ["/proc/meminfo"]) |> Kernel.elem(0)
    mem_a = String.slice(a_mem, 28..51)
    mem_a_clean = String.replace(mem_a, ":          ", "")
    # IO.inspect(mem_a_clean)
    create_mem_a_atom = String.slice(mem_a_clean, 0..6) |> String.to_atom()
    create_mem_a_int = String.slice(mem_a_clean, 7..12) |> String.to_integer()

    # Insert cleaned data
    Mem.create_meminfo(%{
      create_mem_a_atom => create_mem_a_int,
    })

  end

  def schedule_work() do
    Process.send_after(self(), :work, 10_000)
  end

end