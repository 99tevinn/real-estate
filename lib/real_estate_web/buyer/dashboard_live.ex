# lib/real_estate_web/live/buyer/dashboard_live.ex
defmodule RealEstateWeb.Buyer.DashboardLive do
  use RealEstateWeb, :live_view
  alias RealEstate.Properties

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(RealEstate.PubSub, "enquiries")
    end
    {:ok, load_data(socket)}
  end

  defp load_data(socket) do
    buyer_id = socket.assigns.current_user.id
    assign(socket,
      enquiries: Properties.list_buyer_enquiries(buyer_id),
      listings:  Properties.list_available_properties()
    )
  end
end
