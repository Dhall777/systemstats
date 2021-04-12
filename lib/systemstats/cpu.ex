# The Cpu context -> houses API pipielines of Cpu data, along with related schemas/tables + changesets + pubsub utilities
defmodule Systemstats.Cpu do
  import Ecto.Query, warn: false

  alias Systemstats.Repo
  alias Systemstats.Cpu.Cpuinfo

  # topic naming for pubsub uses the module name, to keep things unique. I don't think you can have duplicate module names...maybe...
  @topic inspect(__MODULE__)

  # BEGIN API CONFIGURATION
  #
  # Returns a list of all cpuinfo records
  def list_cpuinfos do
    Repo.all(Cpuinfos)
  end

  # Returns a single record of cpuinfo
  def get_cpuinfo!(id), do: Repo.get!(Cpuinfo, id)

  # Create cpuinfo and insert new record into cpuinfos table
  # Then, broadcast status to subscribers via notification, which is delivered in their local message box
  def create_cpuinfo(attrs \\ %{}) do
    %Cpuinfo{}
    |> Cpuinfo.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:cpuinfo_inserted)
  end

  # Update cpuinfo record
  def update_cpuinfo(%Cpuinfo{} = cpuinfo, attrs) do
    cpuinfo
    |> Cpuinfo.changeset(attrs)
    |> Repo.update()
  end

  # Deletes cpuinfo record
  def delete_cpuinfo(%Cpuinfo{} = cpuinfo) do
    Repo.delete(cpuinfo)
  end

  # Returns an Ecto changeset for tracking cpuinfo changes
  def change_cpuinfo(%Cpuinfo{} = cpuinfo, attrs \\ %{}) do
    Cpuinfo.changeset(cpuinfo, attrs)
  end

  # BEGIN PUBSUB CONFIGURATION
  #
  # Subscribe to this context module's messages -> piece of this context's pubsub mechanism
  def subscribe do
    Phoenix.PubSub.subscribe(Systemstats.PubSub, @topic)
  end

  # Broadcast a message to subscribers when something happens -> another piece of this context's pubsub mechanism
  def broadcast({:ok, record}, event) do
    Phoenix.PubSub.broadcast(Systemstats.PubSub, @topic, {event, record})
    {:ok, record}
  end

  # Error handling for broadcasts
  def broadcast({:error, _} = error, _event), do: error
end
