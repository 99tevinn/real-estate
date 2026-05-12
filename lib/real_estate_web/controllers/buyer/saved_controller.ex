defmodule RealEstateWeb.Buyer.SavedController do
  use RealEstateWeb, :controller
  alias RealEstate.Properties

  def index(conn, _params) do
    buyer_id = conn.assigns.current_user.id
    saved    = Properties.list_saved_listings(buyer_id)
    render(conn, :index, saved: saved)
  end

  def create(conn, %{"property_id" => property_id}) do
    buyer_id = conn.assigns.current_user.id

    case Properties.save_listing(%{"buyer_id" => buyer_id, "property_id" => property_id}) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Property saved.")
        |> redirect(to: ~p"/buyer/saved")

      {:error, _} ->
        conn
        |> put_flash(:error, "Could not save property.")
        |> redirect(to: ~p"/listings")
    end
  end

  def delete(conn, %{"id" => property_id}) do
    buyer_id = conn.assigns.current_user.id
    Properties.unsave_listing(buyer_id, String.to_integer(property_id))

    conn
    |> put_flash(:info, "Property removed from saved.")
    |> redirect(to: ~p"/buyer/saved")
  end
end
