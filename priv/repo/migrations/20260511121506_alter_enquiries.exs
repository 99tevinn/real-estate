defmodule RealEstate.Repo.Migrations.AlterEnquiries do
  use Ecto.Migration

  def change do
    alter table(:enquiries) do
      add(:inserted_at, :utc_datetime)
      add(:updated_at, :utc_datetime)
    end
  end
end
