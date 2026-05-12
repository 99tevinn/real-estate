defmodule RealEstate.Repo.Migrations.CreateEnquiries do
  use Ecto.Migration

  def change do
    create table(:enquiries) do
      add :message, :text, null: false
      add :status, :string, default: "pending"
      add :property_id, references(:properties, on_delete: :delete_all)
      add :buyer_id, references(:users, on_delete: :delete_all)
    end
  end
end
