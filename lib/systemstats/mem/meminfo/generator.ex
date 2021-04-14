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
    # (a) generate & insert MemFree data from /proc/meminfo
    a_mem = System.cmd("cat", ["/proc/meminfo"]) |> Kernel.elem(0)
    mem_a = String.slice(a_mem, 28..51)
    mem_a_clean = String.replace(mem_a, ":          ", "")
    create_mem_a_atom = String.slice(mem_a_clean, 0..6) |> String.to_atom()
    create_mem_a_int = String.slice(mem_a_clean, 7..12) |> String.to_integer()

    # (b) generate & insert MemAvailable data from /proc/meminfo
    b_mem = System.cmd("cat", ["/proc/meminfo"]) |> Kernel.elem(0)
    mem_b = String.slice(b_mem, 56..79)
    mem_b_clean = String.replace(mem_b, ":     ", "")
    create_mem_b_atom = String.slice(mem_b_clean, 0..11) |> String.to_atom()
    create_mem_b_int = String.slice(mem_b_clean, 12..17) |> String.to_integer()

    # (c) generate & insert Buffers data from /proc/meminfo
    c_mem = System.cmd("cat", ["/proc/meminfo"]) |> Kernel.elem(0)
    mem_c = String.slice(b_mem, 84..107)
    mem_c_clean = String.replace(mem_c, ":          ", "")
    create_mem_c_atom = String.slice(mem_c_clean, 0..6) |> String.to_atom()
    create_mem_c_int = String.slice(mem_c_clean, 7..12) |> String.to_integer()

    # (d) generate & insert Cached data from /proc/meminfo
    d_mem = System.cmd("cat", ["/proc/meminfo"]) |> Kernel.elem(0)
    mem_d = String.slice(d_mem, 112..135)
    mem_d_clean = String.replace(mem_d, ":           ", "")
    create_mem_d_atom = String.slice(mem_d_clean, 0..5) |> String.to_atom()
    create_mem_d_int = String.slice(mem_d_clean, 6..11) |> String.to_integer()

    # (e) generate & insert Active data from /proc/meminfo
    e_mem = System.cmd("cat", ["/proc/meminfo"]) |> Kernel.elem(0)
    mem_e = String.slice(e_mem, 168..191)
    mem_e_clean = String.replace(mem_e, ":           ", "")
    create_mem_e_atom = String.slice(mem_e_clean, 0..5) |> String.to_atom()
    create_mem_e_int = String.slice(mem_e_clean, 6..11) |> String.to_integer()

    # (f) generate & insert Dirty data from /proc/meminfo
    f_mem = System.cmd("cat", ["/proc/meminfo"]) |> Kernel.elem(0)
    mem_f = String.slice(f_mem, 448..471)
    mem_f_clean = String.replace(mem_f, ":                 ", "")
    create_mem_f_atom = String.slice(mem_f_clean, 0..4) |> String.to_atom()
    create_mem_f_int = String.slice(mem_f_clean, 5..6) |> String.to_integer()

    # (g) generate & insert SwapFree data from /proc/meminfo
    g_mem = System.cmd("cat", ["/proc/meminfo"]) |> Kernel.elem(0)
    mem_g = String.slice(g_mem, 420..443)
    mem_g_clean = String.replace(mem_g, ":        ", "")
    create_mem_g_atom = String.slice(mem_g_clean, 0..7) |> String.to_atom()
    create_mem_g_int = String.slice(mem_g_clean, 8..14) |> String.to_integer()

    # (h) generate & insert NFS_Unstable data from /proc/meminfo
    h_mem = System.cmd("cat", ["/proc/meminfo"]) |> Kernel.elem(0)
    mem_h = String.slice(h_mem, 728..751)
    mem_h_clean = String.replace(mem_h, ":          ", "")
    create_mem_h_atom = String.slice(mem_h_clean, 0..11) |> String.to_atom()
    create_mem_h_int = String.slice(mem_h_clean, 12..12) |> String.to_integer()

    # (i) generate & insert Writeback data from /proc/meminfo
    # (j) generate & insert PageTables data from /proc/meminfo

    # Insert cleaned data
    Mem.create_meminfo(%{
      create_mem_a_atom => create_mem_a_int,
      create_mem_b_atom => create_mem_b_int,
      create_mem_c_atom => create_mem_c_int,
      create_mem_d_atom => create_mem_d_int,
      create_mem_e_atom => create_mem_e_int,
      create_mem_f_atom => create_mem_f_int,
      create_mem_g_atom => create_mem_g_int,
      create_mem_h_atom => create_mem_h_int,
    })
  end

  def schedule_work() do
    Process.send_after(self(), :work, 10_000)
  end

end
