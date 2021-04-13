defmodule Systemstats.Mem.Meminfo do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false

  schema "meminfos" do
    field(:MemTotal, :integer)
    field(:MemFree, :integer)
    field(:MemAvailable, :integer)
    field(:Buffers, :integer)
    field(:Cached, :integer)
    field(:SwapCached, :integer)
    field(:Active, :integer)
    field(:Inactive, :integer)
    field(:SwapTotal, :integer)
    field(:SwapFree, :integer)
    field(:Dirty, :integer)
    field(:Writeback, :integer)
    field(:PageTables, :integer)
    field(:NFS_Unstable, :integer)

    timestamps()
  end

  def changeset(cpuinfo, attrs \\ %{}) do
    cpuinfo
    |> cast(attrs, [
      :MemTotal,
      :MemFree,
      :MemAvailable,
      :Buffers,
      :Cached,
      :SwapCached,
      :Active,
      :Inactive,
      :SwapTotal,
      :SwapFree,
      :Dirty,
      :Writeback,
      :PageTables,
      :NFS_Unstable,
    ])

    #    |> validate_required([
    #      
    #    ])
  end
end

