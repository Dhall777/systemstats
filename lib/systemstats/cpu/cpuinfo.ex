defmodule Systemstats.Cpu.Cpuinfo do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false

  schema "cpuinfos" do
    field(:processor, :integer)
    field(:vendor_id, :string)
    field(:cpu_family, :integer)
    field(:model, :integer)
    field(:model_name, :string)
    field(:stepping, :integer)
    field(:microcode, :string)
    field(:cpu_MHz, :float)
    field(:cpu_cores, :integer)

    timestamps()
  end

  def changeset(cpuinfo, attrs \\ %{}) do
    cpuinfo
    |> cast(attrs, [
      :processor,
      :vendor_id,
      :cpu_family,
      :model,
      :model_name,
      :stepping,
      :microcode,
      :cpu_MHz,
      :cpu_cores
    ])

    #    |> validate_required([
    #      :processor,
    #      :vendor_id,
    #      :cpu_family,
    #      :model,
    #      :model_name,
    #      :stepping,
    #      :microcode,
    #      :cpu_MHz,
    #      :cpu_cores
    #    ])
  end
end
