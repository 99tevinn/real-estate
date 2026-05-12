defmodule RealEstate.Repo.Migrations.CreateProperties do
  use Ecto.Migration

  def change do
    create table(:properties) do
      add :title, :string, null: false
      add :description, :text
      add :price, :decimal
      add :location, :string
      add :status, :string, default: "available"
      add :type, :string
      add :owner_id, references(:users, on_delete: :delete_all)
      add :agent_id, references(:users, on_delete: :nilify_all)
      timestamps()
    end

    create index(:properties, [:owner_id])
    create index(:properties, [:agent_id])
  end
end
