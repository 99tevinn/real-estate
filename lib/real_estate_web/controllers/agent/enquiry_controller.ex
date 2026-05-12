defmodule RealEstateWeb.Agent.EnquiryController do
  use RealEstateWeb, :controller
  alias RealEstate.Properties

  def index(conn, _params) do
    enquiries = Properties.list_pending_enquiries()
    render(conn, :index, enquiries: enquiries)
  end

  def show(conn, %{"id" => id}) do
    enquiry = Properties.get_enquiry!(id)
    render(conn, :show, enquiry: enquiry)
  end

  def update(conn, %{"id" => id, "enquiry" => params}) do
    enquiry = Properties.get_enquiry!(id)

    case Properties.update_enquiry(enquiry, params) do
      {:ok, _enquiry} ->
        conn
        |> put_flash(:info, "Enquiry status updated.")
        |> redirect(to: ~p"/agent/enquiries")

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Could not update enquiry.")
        |> redirect(to: ~p"/agent/enquiries")
    end
  end
end
