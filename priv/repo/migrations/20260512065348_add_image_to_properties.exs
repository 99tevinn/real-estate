defmodule RealEstate.Repo.Migrations.AddImageToProperties do
  use Ecto.Migration

  def change do
    alter table(:properties) do
      add :image, :string
    end
  end
end
