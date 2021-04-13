defmodule Systemstats.Repo.Migrations.CreateMeminfos do
  use Ecto.Migration

  def change do
    create table(:meminfos) do
      add :MemTotal, :integer
      add :MemFree, :integer
      add :MemAvailable, :integer
      add :Buffers, :integer
      add :Cached, :integer
      add :SwapCached, :integer
      add :Active, :integer
      add :Inactive, :integer
      add :SwapTotal, :integer
      add :SwapFree, :integer
      add :Dirty, :integer
      add :Writeback, :integer
      add :PageTables, :integer
      add :NFS_Unstable, :integer

      timestamps()
    end
  end
end
