defmodule Systemstats.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repositories (each have their own DB)
      Systemstats.ShackletonRepo,
      Systemstats.BattutaRepo,
      Systemstats.KupeRepo,
      Systemstats.TabeiRepo,
      # Start the Telemetry supervisor
      SystemstatsWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Systemstats.PubSub},
      # Start the Endpoint (http/https)
      SystemstatsWeb.Endpoint
      # Start a worker by calling: Systemstats.Worker.start_link(arg)
      # {Systemstats.Worker, arg}
      # Start the generators for OS statistics -> specific details per-generator can be found in its respective context/sub-context
      # Systemstats.Cpu.Cpuinfo.Generator,
      # Systemstats.Mem.Meminfo.Generator
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Systemstats.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    SystemstatsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
