defmodule RealEstateWeb.Owner.DashboardLive do
  use RealEstateWeb, :live_view
  alias RealEstate.Properties

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(RealEstate.PubSub, "enquiries")
    end

    {:ok, load_data(socket)}
  end

  def handle_info({:new_enquiry, _}, socket) do
    {:noreply, load_data(socket)}
  end

  defp load_data(socket) do
    owner_id = socket.assigns.current_user.id
    properties_result = Properties.list_owner_properties(owner_id)
    enquiries_result = Properties.list_owner_enquiries(owner_id)

    assign(socket,
      properties: if(is_map(properties_result), do: properties_result.entries, else: properties_result),
      enquiries: enquiries_result
    )
  end
end
