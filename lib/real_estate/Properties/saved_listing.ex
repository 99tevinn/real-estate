defmodule RealEstate.Properties.SavedListing do
  use Ecto.Schema
  import Ecto.Changeset

  schema "saved_listings" do
    belongs_to :user, RealEstate.Accounts.User
    belongs_to :property, RealEstate.Properties.Property

    timestamps()
  end

  @doc false
  def changeset(saved_listing, attrs) do
    saved_listing
    |> cast(attrs, [:buyer_id, :property_id])
    |> validate_required([:buyer_id, :property_id])
    |> unique_constraint([:buyer_id, :property_id],
      message: "Property already saved"
    )
  end
end
