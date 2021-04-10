# The Datastreams context -> houses API pipielines of system data, along with related schemas/tables + changesets + pubsub utilities
defmodule Systemstats.Datastreams do
  import Ecto.Query, warn: false

  alias Systemstats.Repo
  alias Systemstats.Datastreams.Cpustream

  # topic naming for pubsub uses the module name, to keep things unique. I don't think you can have duplicate module names...maybe...
  @topic inspect(__MODULE__)

  # BEGIN API CONFIGURATION
  #
  # Returns a list of all cpustreams
  def list_cpustreams do
    Repo.all(Cpustream)
  end

  # Returns a single cpustream
  def get_cpustream!(id), do: Repo.get!(Cpustream, id)

  # Create cpustream and insert new record into cpustreams table
  # Then, broadcast status to subscribers via notification, which is delivered in their local message box
  def create_cpustream(attrs \\ %{}) do
    %Cpustream{}
    |> Cpustream.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:cpustream_inserted)
  end

  # Update cpustream record
  def update_cpustream(%Cpustream{} = cpustream, attrs) do
    cpustream
    |> Cpustream.changeset(attrs)
    |> Repo.update()
  end

  # Deletes cpustream record
  def delete_cpustream(%Cpustream{} = cpustream) do
    Repo.delete(cpustream)
  end

  # Returns an Ecto changeset for tracking cpustream changes
  def change_cpustream(%Cpustream{} = cpustream, attrs \\ %{}) do
    Cpustream.changeset(cpustream, attrs)
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
