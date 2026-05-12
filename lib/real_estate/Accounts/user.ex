defmodule RealEstate.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @roles ["admin", "agent", "owner", "buyer"]

  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :role, :string, default: "buyer"
    field :full_name, :string
    field :active, :boolean, default: true

    has_many :properties, RealEstate.Properties.Property, foreign_key: :agent_id
    has_many :enquiries_made, RealEstate.Properties.Enquiry, foreign_key: :buyer_id

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :role, :full_name, :active])
    |> validate_required([:email, :password])
    |> validate_inclusion(:role, @roles)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> hash_password()
  end

  def admin_changeset(user, attrs) do
    user
    |> cast(attrs, [:role, :full_name, :active])
    |> validate_required([:role])
    |> validate_inclusion(:role, @roles)
  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: pw}} = cs) do
    case pw do
      "" -> add_error(cs, :password, "can't be blank")
      _  -> put_change(cs, :password_hash, Bcrypt.hash_pwd_salt(pw))
    end
  end

  defp hash_password(cs), do: cs
end
