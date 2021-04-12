defmodule Systemstats.Repo.Migrations.CreateCpuinfos do
  use Ecto.Migration

  def change do
    create table(:cpuinfos) do
      add :processor, :integer
      add :vendor_id, :string
      add :cpu_family, :integer
      add :model, :integer
      add :model_name, :string
      add :stepping, :integer
      add :microcode, :string
      add :cpu_MHz, :float
      add :cpu_cores, :integer

      timestamps()
    end
  end
end
