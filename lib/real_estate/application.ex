defmodule RealEstate.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      RealEstateWeb.Telemetry,
      RealEstate.Repo,
      {DNSCluster, query: Application.get_env(:real_estate, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: RealEstate.PubSub},
      # Start a worker by calling: RealEstate.Worker.start_link(arg)
      # {RealEstate.Worker, arg},
      # Start to serve requests, typically the last entry
      RealEstateWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RealEstate.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RealEstateWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
