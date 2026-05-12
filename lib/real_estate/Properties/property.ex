defmodule RealEstate.Properties.Property do
  use Ecto.Schema
  use Waffle.Ecto.Schema
  import Ecto.Changeset

  schema "properties" do
    field :title, :string
    field :description, :string
    field :price, :decimal
    field :location, :string
    field :status, :string, default: "available"
    field :type, :string
    field :image, RealEstate.Uploaders.PropertyImage.Type

    belongs_to :owner, RealEstate.Accounts.User
    belongs_to :agent, RealEstate.Accounts.User
    has_many :enquiries, RealEstate.Properties.Enquiry

    timestamps()
  end

  @valid_statuses ["available", "sold", "rented"]
  @valid_types ["sale", "rent"]

  def changeset(property, attrs) do
    property
    |> cast(attrs, [:title, :description, :price, :location, :status, :type, :owner_id, :agent_id])
    |> cast_attachments(attrs, [:image])
    |> validate_required([:title, :price, :location, :type])
    |> validate_inclusion(:status, @valid_statuses)
    |> validate_inclusion(:type, @valid_types)
    |> validate_number(:price, greater_than: 0)
  end
end
