defmodule RealEstateWeb.Owner.EnquiryController do
  use RealEstateWeb, :controller
  alias RealEstate.Properties

  def index(conn, _params) do
    owner_id  = conn.assigns.current_user.id
    enquiries = Properties.list_owner_enquiries(owner_id)
    render(conn, :index, enquiries: enquiries)
  end
end
