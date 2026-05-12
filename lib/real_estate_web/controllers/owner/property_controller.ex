defmodule RealEstateWeb.Owner.PropertyController do
  use RealEstateWeb, :controller
  alias RealEstate.Properties
  alias RealEstate.Properties.Property

  def index(conn, _params) do
    owner_id = conn.assigns.current_user.id
    properties = Properties.list_owner_properties(owner_id)
    render(conn, :index, properties: properties)
  end

  def new(conn, _params) do
    changeset = Properties.change_property(%Property{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"property" => params}) do
    owner_id = conn.assigns.current_user.id
    params = Map.put(params, "owner_id", owner_id)

    case Properties.create_property(params) do
      {:ok, _property} ->
        conn
        |> put_flash(:info, "Property listed successfully.")
        |> redirect(to: ~p"/owner/properties")

      {:error, changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    property = Properties.get_owner_property!(conn.assigns.current_user.id, id)
    changeset = Properties.change_property(property)
    render(conn, :edit, property: property, changeset: changeset)
  end

  def update(conn, %{"id" => id, "property" => params}) do
    property = Properties.get_owner_property!(conn.assigns.current_user.id, id)

    case Properties.update_property(property, params) do
      {:ok, _property} ->
        conn
        |> put_flash(:info, "Property updated.")
        |> redirect(to: ~p"/owner/properties")

      {:error, changeset} ->
        render(conn, :edit, property: property, changeset: changeset)
    end
  end
end
