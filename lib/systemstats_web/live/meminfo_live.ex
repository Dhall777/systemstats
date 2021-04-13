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
      |> Enum.map(fn %{inserted_at: timestamp, MemFree: memfree} ->
        [timestamp, memfree]
      end)

    metalist_to_struct =
      map_to_metalist
      |> Dataset.new(["Time", "MemFree"])

    struct_to_plot_params =
      metalist_to_struct
      |> Plot.new(
        LinePlot,
        600,
        300,
        mapping: %{x_col: "Time", y_cols: ["MemFree"]},
        plot_options: plot_options,
        title: "Memory info (general)",
        x_label: "Time (UTC)",
        y_label: "Memory used (kB)",
        legend_setting: :legend_right
      )

    # Generate SVG
    meminfo_lineplot = struct_to_plot_params |> Plot.to_svg()
  end

  def render(assigns) do
    ~L"""
      <div class="column">
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

  # Handle pubsub message, then update socket with new assigns to trigger page re-render
  def handle_info({:meminfo_inserted, new_meminfo}, socket) do
    updated_meminfos = socket.assigns[:meminfos] ++ [new_meminfo]

    {:noreply, socket |> assign(:meminfos, updated_meminfos)}
  end
end
