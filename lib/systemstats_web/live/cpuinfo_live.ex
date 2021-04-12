defmodule SystemstatsWeb.CpuinfoLive do
  # use Phoenix.LiveView
  use SystemstatsWeb, :live_view
  use Phoenix.HTML

  import Ecto.Query, warn: false

  alias Systemstats.Cpu
  alias Systemstats.Cpu.Cpuinfo.{ChartQuery}
  alias Contex.{Dataset, LinePlot, Plot}

  def make_cpufreq_lineplot do
    cpufreq_data = ChartQuery.fetch_cpuinfo_plotdata({0})

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
      cpufreq_data
      |> Enum.map(fn %{inserted_at: timestamp, processor: processor, cpu_MHz: cpu_MHz} ->
        [timestamp, processor, cpu_MHz]
      end)

    metalist_to_struct =
      map_to_metalist
      |> Dataset.new(["Time", "Processor", "cpu_MHz"])

    struct_to_plot_params =
      metalist_to_struct
      |> Plot.new(
        LinePlot,
        600,
        300,
        mapping: %{x_col: "Time", y_cols: ["cpu_MHz"]},
        plot_options: plot_options,
        title: "core: 0",
        x_label: "Time (UTC)",
        y_label: "core frequency (MHz)",
        legend_setting: :legend_right
      )

    # Generate SVG
    cpufreq_lineplot = struct_to_plot_params |> Plot.to_svg()
  end

  def render(assigns) do
    ~L"""
      <div class="column">
        <%= make_cpufreq_lineplot %>
      </div>
    """
  end

  # Subscribe to pubsub topic when liveview is connected (check contexts for pubsub mechanisms)
  # Then, assign the chart view to the socket
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Cpu.subscribe()
    end

    # {:ok, socket}
    {:ok, socket, temporary_assigns: [cpuinfos: []]}
  end

  # Handle pubsub message, which refreshes page
  # Also, fix the "no function clause matching" error; why is the message being delivered, even with this error?
  def handle_info({:cpuinfo_inserted, new_cpuinfo}, socket) do
    updated_cpuinfos = socket.assigns[:cpuinfos] ++ [new_cpuinfo]

    {:noreply, socket |> assign(:cpuinfos, updated_cpuinfos)}
  end
end
