defmodule RealEstateWeb.Admin.DashboardLive do
  use RealEstateWeb, :live_view
  alias RealEstate.{Accounts, Properties}

  @refresh_interval 30_000

  def mount(_params, _session, socket) do
    if connected?(socket) do
    Phoenix.PubSub.subscribe(RealEstate.PubSub, "enquiries")
    Phoenix.PubSub.subscribe(RealEstate.PubSub, "properties")
    :timer.send_interval(@refresh_interval, self(), :refresh)
    end

    {:ok, load_stats(socket)}
  end

  def handle_info(:refresh, socket) do
    {:noreply, load_stats(socket)}
  end

  def handle_info({:new_enquiry, _}, socket) do
    {:noreply, load_stats(socket)}
  end

  def handle_info({:updated_property, _}, socket) do
    {:noreply, load_stats(socket)}
  end

  def handle_info({:new_property, _}, socket) do
    {:noreply, load_stats(socket)}
  end

  defp load_stats(socket) do
    assign(socket,
      total_users: Accounts.count_users(),
      total_properties: Properties.count_properties(),
      total_enquiries: Properties.count_enquiries(),
      recent_users: Accounts.list_recent_users(5)
    )
  end
end
