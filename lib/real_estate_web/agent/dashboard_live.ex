defmodule RealEstateWeb.Agent.DashboardLive do
  use RealEstateWeb, :live_view
  alias RealEstate.Properties

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(RealEstate.PubSub, "enquiries")
      Phoenix.PubSub.subscribe(RealEstate.PubSub, "properties")
    end
    {:ok, load_data(socket)}
  end

  def handle_info({:new_enquiry, _}, socket) do
    {:noreply, load_data(socket)}
  end

  defp load_data(socket) do
    assign(socket,
      listings:          Properties.list_agent_listings(socket.assigns.current_user.id),
      pending_enquiries: Properties.list_pending_enquiries()
    )
  end
end
