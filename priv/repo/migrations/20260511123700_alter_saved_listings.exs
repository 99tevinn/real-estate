defmodule RealEstate.Repo.Migrations.AlterSavedListings do
  use Ecto.Migration

  def change do
      create index(:saved_listings, [:user_id])
      create index(:saved_listings, [:property_id])
  end
end
