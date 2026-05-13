defmodule RealEstateWeb.PageController do
  use RealEstateWeb, :controller
  alias RealEstate.Properties

  def home(conn, params) do
    listings = Properties.search_properties(params)
    render(conn, :home, listings: listings)
  end
end
