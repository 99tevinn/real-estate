defmodule RealEstateWeb.Buyer.EnquiryController do
  use RealEstateWeb, :controller
  alias RealEstate.Properties
  alias RealEstate.Properties.Enquiry

  def index(conn, _params) do
    buyer_id = conn.assigns.current_user.id
    enquiries = RealEstate.Properties.list_buyer_enquiries(buyer_id)

    render(conn, :index, enquiries: enquiries)
  end

  def new(conn, %{"property_id" => property_id}) do
    changeset = Properties.change_enquiry(%Enquiry{})
    property = Properties.get_property!(property_id)
    render(conn, :new, changeset: changeset, property: property)
  end

  def create(conn, %{"enquiry" => params}) do
    buyer_id = conn.assigns.current_user.id
    params = Map.put(params, "buyer_id", buyer_id)

    case Properties.create_enquiry(params) do
      {:ok, _enquiry} ->
        conn
        |> put_flash(:info, "Enquiry sent successfully.")
        |> redirect(to: ~p"/buyer/enquiries")

      {:error, changeset} ->
        property = Properties.get_property!(params["property_id"])
        render(conn, :new, changeset: changeset, property: property)
    end
  end
end
