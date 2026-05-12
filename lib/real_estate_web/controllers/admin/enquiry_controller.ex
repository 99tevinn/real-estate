# lib/real_estate_web/controllers/admin/enquiry_controller.ex
defmodule RealEstateWeb.Admin.EnquiryController do
  use RealEstateWeb, :controller
  alias RealEstate.Properties

  def index(conn, _params) do
    enquiries = Properties.list_all_enquiries()
    render(conn, :index, enquiries: enquiries)
  end

  def show(conn, %{"id" => id}) do
    enquiry = Properties.get_enquiry!(id)
    render(conn, :show, enquiry: enquiry)
  end

  def delete(conn, %{"id" => id}) do
    enquiry = Properties.get_enquiry!(id)
    Properties.delete_enquiry(enquiry)

    conn
    |> put_flash(:info, "Enquiry deleted.")
    |> redirect(to: ~p"/admin/enquiries")
  end
end
