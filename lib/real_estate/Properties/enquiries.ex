defmodule RealEstate.Properties.Enquiry do
  use Ecto.Schema
  import Ecto.Changeset

  schema "enquiries" do
    field :message, :string
    field :status, :string, default: "pending"

    belongs_to :property, RealEstate.Properties.Property
    belongs_to :buyer, RealEstate.Accounts.User

    timestamps()
  end

  @valid_statuses ["pending", "replied", "closed"]

  def changeset(enquiry, attrs) do
    enquiry
    |> cast(attrs, [:message, :status, :property_id, :buyer_id])
    |> validate_required([:message, :property_id, :buyer_id])
    |> validate_inclusion(:status, @valid_statuses)
    |> validate_length(:message, min: 10, max: 1000)
  end
end
