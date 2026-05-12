defmodule RealEstate.Repo.Migrations.CreateSavedListings do
  use Ecto.Migration

  def change do
    create table(:saved_listings) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :property_id, references(:properties, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:saved_listings, [:user_id, :property_id])
  end
end
