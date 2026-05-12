# lib/real_estate_web/controllers/listing_controller.ex
defmodule RealEstateWeb.ListingController do
  use RealEstateWeb, :controller
  alias RealEstate.Properties

  def index(conn, params) do
    listings = Properties.search_properties(params)

    render(conn, :index,
      listings: listings.entries,
      filters: params,
      page_number: listings.page_number,
      total_pages: listings.total_pages
    )
  end

  def show(conn, %{"id" => id}) do
    listing = Properties.get_property!(id)
    render(conn, :show, listing: listing)
  end
end
