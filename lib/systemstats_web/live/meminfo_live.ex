defmodule SystemstatsWeb.MeminfoLive do
  # use Phoenix.LiveView
  use SystemstatsWeb, :live_view
  use Phoenix.HTML

  import Ecto.Query, warn: false

  alias Systemstats.Mem
  alias Systemstats.Mem.Meminfo.{ChartQuery}
  alias Contex.{Dataset, LinePlot, Plot}

  def make_meminfo_lineplot do
    meminfo_data = ChartQuery.fetch_meminfo_plotdata()

    plot_options = %{
      top_margin: 5,
      right_margin: 5,
      bottom_margin: 5,
      left_margin: 5,
      smoothed: false,
      colour_palette: :default,
      show_x_axis: true,
      show_y_axis: true
    }

    map_to_metalist =
      meminfo_data
      |> Enum.map(fn %{inserted_at: timestamp, MemAvailable: memavailable, Buffers: buffers, Cached: cached, Active: active, SwapFree: swapfree, PageTables: pagetables} ->
        [timestamp, memavailable, buffers, cached, active, swapfree, pagetables]
      end)

    metalist_to_struct =
      map_to_metalist
      |> Dataset.new(["Time", "MemAvailable", "Buffers", "Cached", "Active", "SwapFree", "PageTables"])

    struct_to_plot_params =
      metalist_to_struct
      |> Plot.new(
        LinePlot,
        950,
        550,
        mapping: %{x_col: "Time", y_cols: ["MemAvailable", "Buffers", "Cached", "Active", "SwapFree", "PageTables"]},
        plot_options: plot_options,
        title: "Memory info - Kupe",
        x_label: "Time - UTC",
        y_label: "Memory - kB",
        legend_setting: :legend_right
      )

    # Generate SVG
    meminfo_lineplot = struct_to_plot_params |> Plot.to_svg()
  end

  def render(assigns) do
    ~L"""
      <div class="row">
        <phx-click="meminfo_manpage"><a href="/meminfo_manpage"</a>
      </div>

      <div class="row">
        <%= make_meminfo_lineplot %>
      </div>
    """
  end

  # Subscribe to pubsub topic when liveview is connected (check contexts for pubsub mechanisms)
  # Then, assign the chart view to the socket, if connected
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Mem.subscribe()
    end

    # {:ok, socket}
    {:ok, socket, temporary_assigns: [meminfos: []]}
  end

  # Handle pubsub message, which triggers the socket to update "assigns" data; this event results in re-render of changed data
  def handle_info({:meminfo_inserted, new_meminfo}, socket) do
    updated_meminfos = socket.assigns[:meminfos] ++ [new_meminfo]

    {:noreply, socket |> assign(:meminfos, updated_meminfos)}
  end

  # Handle phx-click event; this event routes users to the 'meminfo' manpage
  def handle_event("meminfo_manpage", _value, socket) do
    {:noreply, socket}
  end
end
