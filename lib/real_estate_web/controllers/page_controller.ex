defmodule RealEstateWeb.PageController do
  use RealEstateWeb, :controller
  alias RealEstate.Properties

  def home(conn, _params) do
    listings = Properties.list_available_properties()
    render(conn, :home, listings: listings)
  end
end
