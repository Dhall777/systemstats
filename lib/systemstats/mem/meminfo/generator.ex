defmodule Systemstats.Mem.Meminfo.Generator do
  alias Systemstats.Mem

  use GenServer

  import Ecto.Query, warn: false

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{})
  end

  def schedule_work() do
    Process.send_after(self(), :work, 10_000)
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
    # (a) generate MemFree data from /proc/meminfo
    a_mem_raw = System.cmd("cat", ["/proc/meminfo"]) |> Kernel.elem(0) 
    a_mem_prep_a = String.replace(a_mem_raw, ~r(kB\n), "")
    a_mem_prep_b = String.replace(a_mem_prep_a, ~r(0\n), "")
    a_mem_prep_c = String.replace(a_mem_prep_b, ~r(:), "")
    a_mem_prep_d = String.replace(a_mem_prep_c, ~r( ), "")
    a_mem_prep_e = String.replace(a_mem_prep_d, ~r(_), "0")
    a_mem_prep_final = Regex.run(~r(MemFree[0-9]{1,100}), a_mem_prep_e) |> List.to_string()
    create_mem_a_atom = String.slice(a_mem_prep_final, 0..6) |> String.to_atom()
    create_mem_a_int = String.slice(a_mem_prep_final, 7..700) |> String.to_integer()

    # (b) generate MemAvailable data from /proc/meminfo
    b_mem_raw = System.cmd("cat", ["/proc/meminfo"]) |> Kernel.elem(0)
    b_mem_prep_a = String.replace(b_mem_raw, ~r(kB\n), "")
    b_mem_prep_b = String.replace(b_mem_prep_a, ~r(0\n), "")
    b_mem_prep_c = String.replace(b_mem_prep_b, ~r(:), "")
    b_mem_prep_d = String.replace(b_mem_prep_c, ~r( ), "")
    b_mem_prep_e = String.replace(b_mem_prep_d, ~r(_), "0")
    b_mem_prep_final = Regex.run(~r(MemAvailable[0-9]{1,100}), b_mem_prep_e) |> List.to_string()
    create_mem_b_atom = String.slice(b_mem_prep_final, 0..11) |> String.to_atom()
    create_mem_b_int = String.slice(b_mem_prep_final, 12..120) |> String.to_integer()

    # (c) generate Buffers data from /proc/meminfo
    c_mem_raw = System.cmd("cat", ["/proc/meminfo"]) |> Kernel.elem(0)
    c_mem_prep_a = String.replace(c_mem_raw, ~r(kB\n), "")
    c_mem_prep_b = String.replace(c_mem_prep_a, ~r(0\n), "")
    c_mem_prep_c = String.replace(c_mem_prep_b, ~r(:), "")
    c_mem_prep_d = String.replace(c_mem_prep_c, ~r( ), "")
    c_mem_prep_e = String.replace(c_mem_prep_d, ~r(_), "0")
    c_mem_prep_final = Regex.run(~r(Buffers[0-9]{1,100}), c_mem_prep_e) |> List.to_string()
    create_mem_c_atom = String.slice(c_mem_prep_final, 0..6) |> String.to_atom()
    create_mem_c_int = String.slice(c_mem_prep_final, 7..700) |> String.to_integer()

    # (d) generate Cached data from /proc/meminfo
    d_mem_raw = System.cmd("cat", ["/proc/meminfo"]) |> Kernel.elem(0)
    d_mem_prep_a = String.replace(d_mem_raw, ~r(kB\n), "")
    d_mem_prep_b = String.replace(d_mem_prep_a, ~r(0\n), "")
    d_mem_prep_c = String.replace(d_mem_prep_b, ~r(:), "")
    d_mem_prep_d = String.replace(d_mem_prep_c, ~r( ), "")
    d_mem_prep_e = String.replace(d_mem_prep_d, ~r(_), "0")
    d_mem_prep_final = Regex.run(~r(Cached[0-9]{1,100}), d_mem_prep_e) |> List.to_string()
    create_mem_d_atom = String.slice(d_mem_prep_final, 0..5) |> String.to_atom()
    create_mem_d_int = String.slice(d_mem_prep_final, 6..600) |> String.to_integer()

    # (e) generate Active data from /proc/meminfo
    e_mem_raw = System.cmd("cat", ["/proc/meminfo"]) |> Kernel.elem(0)
    e_mem_prep_a = String.replace(e_mem_raw, ~r(kB\n), "")
    e_mem_prep_b = String.replace(e_mem_prep_a, ~r(0\n), "")
    e_mem_prep_c = String.replace(e_mem_prep_b, ~r(:), "")
    e_mem_prep_d = String.replace(e_mem_prep_c, ~r( ), "")
    e_mem_prep_e = String.replace(e_mem_prep_d, ~r(_), "0")
    e_mem_prep_final = Regex.run(~r(Active[0-9]{1,100}), e_mem_prep_e) |> List.to_string()
    create_mem_e_atom = String.slice(e_mem_prep_final, 0..5) |> String.to_atom()
    create_mem_e_int = String.slice(e_mem_prep_final, 6..600) |> String.to_integer()

    # (f) generate Dirty data from /proc/meminfo
    f_mem_raw = System.cmd("cat", ["/proc/meminfo"]) |> Kernel.elem(0)
    f_mem_prep_a = String.replace(f_mem_raw, ~r(kB\n), "")
    f_mem_prep_b = String.replace(f_mem_prep_a, ~r(0\n), "")
    f_mem_prep_c = String.replace(f_mem_prep_b, ~r(:), "")
    f_mem_prep_d = String.replace(f_mem_prep_c, ~r( ), "")
    f_mem_prep_e = String.replace(f_mem_prep_d, ~r(_), "0")
    f_mem_prep_final = Regex.run(~r(Dirty[0-9]{1,100}), f_mem_prep_e) |> List.to_string()
    create_mem_f_atom = String.slice(f_mem_prep_final, 0..4) |> String.to_atom()
    create_mem_f_int = String.slice(f_mem_prep_final, 5..500) |> String.to_integer()

    # (g) generate SwapFree data from /proc/meminfo
    g_mem_raw = System.cmd("cat", ["/proc/meminfo"]) |> Kernel.elem(0)
    g_mem_prep_a = String.replace(g_mem_raw, ~r(kB\n), "")
    g_mem_prep_b = String.replace(g_mem_prep_a, ~r(0\n), "")
    g_mem_prep_c = String.replace(g_mem_prep_b, ~r(:), "")
    g_mem_prep_d = String.replace(g_mem_prep_c, ~r( ), "")
    g_mem_prep_e = String.replace(g_mem_prep_d, ~r(_), "0")
    g_mem_prep_final = Regex.run(~r(SwapFree[0-9]{1,100}), g_mem_prep_e) |> List.to_string()
    create_mem_g_atom = String.slice(g_mem_prep_final, 0..7) |> String.to_atom()
    create_mem_g_int = String.slice(g_mem_prep_final, 8..800) |> String.to_integer()

    # (h) generate PageTables data from /proc/meminfo
    h_mem_raw = System.cmd("cat", ["/proc/meminfo"]) |> Kernel.elem(0)
    h_mem_prep_a = String.replace(h_mem_raw, ~r(kB\n), "")
    h_mem_prep_b = String.replace(h_mem_prep_a, ~r(0\n), "")
    h_mem_prep_c = String.replace(h_mem_prep_b, ~r(:), "")
    h_mem_prep_d = String.replace(h_mem_prep_c, ~r( ), "")
    h_mem_prep_e = String.replace(h_mem_prep_d, ~r(_), "0")
    h_mem_prep_final = Regex.run(~r(PageTables[0-9]{1,100}), h_mem_prep_e) |> List.to_string()
    create_mem_h_atom = String.slice(h_mem_prep_final, 0..9) |> String.to_atom()
    create_mem_h_int = String.slice(h_mem_prep_final, 10..1000) |> String.to_integer()

    # (i) generate Writeback data from /proc/meminfo
    i_mem_raw = System.cmd("cat", ["/proc/meminfo"]) |> Kernel.elem(0)
    i_mem_prep_a = String.replace(i_mem_raw, ~r(kB\n), "")
    i_mem_prep_b = String.replace(i_mem_prep_a, ~r(0\n), "")
    i_mem_prep_c = String.replace(i_mem_prep_b, ~r(:), "")
    i_mem_prep_d = String.replace(i_mem_prep_c, ~r( ), "")
    i_mem_prep_e = String.replace(i_mem_prep_d, ~r(_), "0")
    i_mem_prep_final = Regex.run(~r(Writeback[0-9]{1,100}), i_mem_prep_e) |> List.to_string()
    create_mem_i_atom = String.slice(i_mem_prep_final, 0..8) |> String.to_atom()
    create_mem_i_int = String.slice(i_mem_prep_final, 9..900) |> String.to_integer()

    # (j) generate NFS_Unstable data from /proc/meminfo
    j_mem_raw = System.cmd("cat", ["/proc/meminfo"]) |> Kernel.elem(0)
    j_mem_prep_a = String.replace(j_mem_raw, ~r(kB\n), "")
    j_mem_prep_b = String.replace(j_mem_prep_a, ~r(0\n), "")
    j_mem_prep_c = String.replace(j_mem_prep_b, ~r(:), "")
    j_mem_prep_d = String.replace(j_mem_prep_c, ~r( ), "")
    j_mem_prep_e = String.replace(j_mem_prep_d, ~r(_), "0")
    j_mem_prep_f = String.replace(j_mem_prep_e, ~r(NFS0Unstable), "NFS_Unstable")
    j_mem_prep_final = Regex.run(~r(NFS_Unstable[0-9]{1,100}), j_mem_prep_f) |> List.to_string()
    create_mem_j_atom = String.slice(j_mem_prep_final, 0..11) |> String.to_atom()
    create_mem_j_int = String.slice(j_mem_prep_final, 12..1200) |> String.to_integer()

    # (k) generate MemTotal data from /proc/meminfo
    k_mem_raw = System.cmd("cat", ["/proc/meminfo"]) |> Kernel.elem(0)
    k_mem_prep_a = String.replace(k_mem_raw, ~r(kB\n), "")
    k_mem_prep_b = String.replace(k_mem_prep_a, ~r(0\n), "")
    k_mem_prep_c = String.replace(k_mem_prep_b, ~r(:), "")
    k_mem_prep_d = String.replace(k_mem_prep_c, ~r( ), "")
    k_mem_prep_e = String.replace(k_mem_prep_d, ~r(_), "0")
    k_mem_prep_final = Regex.run(~r(MemTotal[0-9]{1,100}), k_mem_prep_e) |> List.to_string()
    create_mem_k_atom = String.slice(k_mem_prep_final, 0..9) |> String.to_atom()
    create_mem_k_int = String.slice(k_mem_prep_final, 10..1000) |> String.to_integer()

    # (l) generate SwapTotal data from /proc/meminfo
    l_mem_raw = System.cmd("cat", ["/proc/meminfo"]) |> Kernel.elem(0)
    l_mem_prep_a = String.replace(l_mem_raw, ~r(kB\n), "")
    l_mem_prep_b = String.replace(l_mem_prep_a, ~r(0\n), "")
    l_mem_prep_c = String.replace(l_mem_prep_b, ~r(:), "")
    l_mem_prep_d = String.replace(l_mem_prep_c, ~r( ), "")
    l_mem_prep_e = String.replace(l_mem_prep_d, ~r(_), "0")
    l_mem_prep_final = Regex.run(~r(SwapTotal[0-9]{1,100}), l_mem_prep_e) |> List.to_string()
    create_mem_l_atom = String.slice(l_mem_prep_final, 0..8) |> String.to_atom()
    create_mem_l_int = String.slice(l_mem_prep_final, 9..900) |> String.to_integer()

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
      create_mem_i_atom => create_mem_i_int,
      create_mem_j_atom => create_mem_j_int,
      create_mem_k_atom => create_mem_k_int,
      create_mem_l_atom => create_mem_l_int,
    })
  end

end
