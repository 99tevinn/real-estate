defmodule RealEstateWeb.Agent.ListingController do
  use RealEstateWeb, :controller
  alias RealEstate.Properties
  alias RealEstate.Properties.Property

  def index(conn, _params) do
    agent_id = conn.assigns.current_user.id
    listings = Properties.list_agent_listings(agent_id)
    render(conn, :index, listings: listings)
  end

  def new(conn, _params) do
    changeset = Properties.change_property(%Property{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"property" => params}) do
    agent_id = conn.assigns.current_user.id
    params = Map.put(params, "agent_id", agent_id)

    case Properties.create_property(params) do
      {:ok, _property} ->
        conn
        |> put_flash(:info, "Listing created successfully.")
        |> redirect(to: ~p"/agent/listings")

      {:error, changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    agent_id = conn.assigns.current_user.id
    listing = Properties.get_agent_listing!(agent_id, id)
    changeset = Properties.change_property(listing)
    render(conn, :edit, listing: listing, changeset: changeset)
  end

  def update(conn, %{"id" => id, "property" => params}) do
    agent_id = conn.assigns.current_user.id
    listing = Properties.get_agent_listing!(agent_id, id)

    case Properties.update_property(listing, params) do
      {:ok, _property} ->
        conn
        |> put_flash(:info, "Listing updated.")
        |> redirect(to: ~p"/agent/listings")

      {:error, changeset} ->
        render(conn, :edit, listing: listing, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    agent_id = conn.assigns.current_user.id
    listing = Properties.get_agent_listing!(agent_id, id)

    case Properties.delete_property(listing) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Listing deleted.")
        |> redirect(to: ~p"/agent/listings")

      {:error, _} ->
        conn
        |> put_flash(:error, "Failed to delete listing.")
        |> redirect(to: ~p"/agent/listings")
    end
  end
end
