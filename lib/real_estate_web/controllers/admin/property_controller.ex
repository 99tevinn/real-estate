# lib/real_estate_web/controllers/admin/property_controller.ex
defmodule RealEstateWeb.Admin.PropertyController do
  use RealEstateWeb, :controller
  alias RealEstate.Properties
  
  def index(conn, _params) do
    properties = Properties.list_all_properties()
    render(conn, :index, properties: properties)
  end

  def edit(conn, %{"id" => id}) do
    property  = Properties.get_property!(id)
    changeset = Properties.change_property(property)
    render(conn, :edit, property: property, changeset: changeset)
  end

  def update(conn, %{"id" => id, "property" => params}) do
    property = Properties.get_property!(id)

    case Properties.update_property(property, params) do
      {:ok, _property} ->
        conn
        |> put_flash(:info, "Property updated.")
        |> redirect(to: ~p"/admin/properties")

      {:error, changeset} ->
        render(conn, :edit, property: property, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    property = Properties.get_property!(id)
    Properties.delete_property(property)

    conn
    |> put_flash(:info, "Property deleted.")
    |> redirect(to: ~p"/admin/properties")
  end
end
