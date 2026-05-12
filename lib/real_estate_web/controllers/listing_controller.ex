# lib/real_estate_web/controllers/listing_controller.ex
defmodule RealEstateWeb.ListingController do
  use RealEstateWeb, :controller
  alias RealEstate.Properties

  def index(conn, params) do
    filters  = Map.take(params, ["type", "location"])
    listings = Properties.list_public_listings(filters)
    render(conn, :index, listings: listings, filters: filters)
  end

  def show(conn, %{"id" => id}) do
    listing = Properties.get_property!(id)
    render(conn, :show, listing: listing)
  end
end
