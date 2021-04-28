# The Mem context -> houses API pipielines of memory data, along with related schemas/tables + changesets + pubsub utilities
defmodule Systemstats.Mem do
  import Ecto.Query, warn: false

  alias Systemstats.ShackletonRepo
  alias Systemstats.BattutaRepo
  alias Systemstats.KupeRepo
  alias Systemstats.TabeiRepo

  alias Systemstats.Mem.Meminfo

  # topic naming for pubsub uses the module name, to keep things unique. I don't think you can have duplicate module names...maybe...
  @topic inspect(__MODULE__)

  # BEGIN API CONFIGURATION
  #
  # Shackleton API functions 
  # Returns a list of all meminfo records from systemstats_shackleton DB
  def shackleton_list_meminfos do
    ShackletonRepo.all(Meminfos)
  end

  # Returns a single record of meminfo
  def shackleton_get_meminfo!(id), do: ShackletonRepo.get!(Meminfo, id)

  # Create meminfo and insert new record into meminfos table
  # Then, broadcast the event to subscribers via notification, which is delivered in their local message box
  def shackleton_create_meminfo(attrs \\ %{}) do
    %Meminfo{}
    |> Meminfo.changeset(attrs)
    |> ShackletonRepo.insert()
    |> broadcast(:meminfo_inserted)
  end

  # Update meminfo record
  def shackleton_update_meminfo(%Meminfo{} = meminfo, attrs) do
    meminfo
    |> Meminfo.changeset(attrs)
    |> ShackletonRepo.update()
  end

  # Deletes meminfo record
  def shackleton_delete_meminfo(%Meminfo{} = meminfo) do
    ShackletonRepo.delete(meminfo)
  end

  # Battuta API functions
  # Returns a list of all meminfo records from systemstats_battuta DB
  def battuta_list_meminfos do
    BattutaRepo.all(Meminfos)
  end

  # Kupe API functions
  # Returns a list of all meminfo records from systemstats_kupe DB
  def kupe_list_meminfos do
    KupeRepo.all(Meminfos)
  end

  # Tabei API functions
  # Returns a list of all meminfo records from systemstats_tabei DB
  def tabei_list_meminfos do
    TabeiRepo.all(Meminfos)
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
