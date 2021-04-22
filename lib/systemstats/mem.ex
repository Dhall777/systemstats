# The Mem context -> houses API pipielines of memory data, along with related schemas/tables + changesets + pubsub utilities
defmodule Systemstats.Mem do
  import Ecto.Query, warn: false

  alias Systemstats.Repo
  alias Systemstats.Mem.Meminfo

  # topic naming for pubsub uses the module name, to keep things unique. I don't think you can have duplicate module names...maybe...
  @topic inspect(__MODULE__)

  # BEGIN API CONFIGURATION
  #
  # Returns a list of all meminfo records
  def list_meminfos do
    Repo.all(Meminfos)
  end

  # Returns a single record of meminfo
  def get_meminfo!(id), do: Repo.get!(Meminfo, id)

  # Create meminfo and insert new record into meminfos table
  # Then, broadcast the event to subscribers via notification, which is delivered in their local message box
  def create_meminfo(attrs \\ %{}) do
    %Meminfo{}
    |> Meminfo.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:meminfo_inserted)
  end

  # Update meminfo record
  def update_meminfo(%Meminfo{} = meminfo, attrs) do
    meminfo
    |> Meminfo.changeset(attrs)
    |> Repo.update()
  end

  # Deletes meminfo record
  def delete_meminfo(%Meminfo{} = meminfo) do
    Repo.delete(meminfo)
  end

  # Returns an Ecto changeset for tracking meminfo changes
  def change_meminfo(%Meminfo{} = meminfo, attrs \\ %{}) do
    Meminfo.changeset(meminfo, attrs)
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
