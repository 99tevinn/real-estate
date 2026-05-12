defmodule RealEstateWeb.Router do
  use RealEstateWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {RealEstateWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug RealEstateWeb.Plugs.LoadCurrentUser
  end

  pipeline :require_admin do
    plug RealEstateWeb.Plugs.RequireRole, ["admin"]
  end

  pipeline :require_agent do
    plug RealEstateWeb.Plugs.RequireRole, ["agent"]
  end

  pipeline :require_owner do
    plug RealEstateWeb.Plugs.RequireRole, ["owner"]
  end

  pipeline :require_buyer do
    plug RealEstateWeb.Plugs.RequireRole, ["buyer"]
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RealEstateWeb do
    pipe_through :browser
    get "/", PageController, :home
    get "/login", SessionController, :new
    post "/login", SessionController, :create
    delete "/logout", SessionController, :delete
    get "/register", RegistrationController, :new
    post "/register", RegistrationController, :create
    get "/listings", ListingController, :index
    get "/listings/:id", ListingController, :show
    get "/forgot-password", PasswordResetController, :new
    post "/forgot-password", PasswordResetController, :create
    get "/password_reset/:token", PasswordResetController, :edit
    put "/password_reset/:token", PasswordResetController, :update
  end

  live_session :admin, on_mount: {RealEstateWeb.LiveAuth, :require_admin} do
    scope "/admin", RealEstateWeb.Admin, as: :admin do
      pipe_through [:browser, :require_admin]
      live "/", DashboardLive
    end
  end

  # Admin — regular routes
  scope "/admin", RealEstateWeb.Admin, as: :admin do
    pipe_through [:browser, :require_admin]
    resources "/users", UserController, except: [:new, :create]
    resources "/properties", PropertyController, except: [:new, :create, :show]
    resources "/enquiries", EnquiryController, only: [:index, :show, :delete]
  end

  # Agent — LiveView dashboard
  live_session :agent, on_mount: {RealEstateWeb.LiveAuth, :require_agent} do
    scope "/agent", RealEstateWeb.Agent, as: :agent do
      pipe_through [:browser, :require_agent]
      live "/", DashboardLive
    end
  end

  # Agent — regular routes
  scope "/agent", RealEstateWeb.Agent, as: :agent do
    pipe_through [:browser, :require_agent]
    resources "/listings", ListingController
    resources "/enquiries", EnquiryController, only: [:index, :show, :update]
  end

  # Owner — LiveView dashboard
  live_session :owner, on_mount: {RealEstateWeb.LiveAuth, :require_owner} do
    scope "/owner", RealEstateWeb.Owner, as: :owner do
      pipe_through [:browser, :require_owner]
      live "/", DashboardLive
    end
  end

  # Owner — regular routes
  scope "/owner", RealEstateWeb.Owner, as: :owner do
    pipe_through [:browser, :require_owner]
    resources "/properties", PropertyController, except: [:delete, :show]
    get "/enquiries", EnquiryController, :index
  end

  # Buyer — LiveView dashboard
  live_session :buyer, on_mount: {RealEstateWeb.LiveAuth, :require_buyer} do
    scope "/buyer", RealEstateWeb.Buyer, as: :buyer do
      pipe_through [:browser, :require_buyer]
      live "/", DashboardLive
    end
  end

  # Buyer — regular routes
  scope "/buyer", RealEstateWeb.Buyer, as: :buyer do
    pipe_through [:browser, :require_buyer]
    get "/saved", SavedController, :index
    post "/saved/:id", SavedController, :create
    delete "/saved/:property_id", SavedController, :delete
    resources "/enquiries", EnquiryController, only: [:new, :create, :index]
  end

  if Application.compile_env(:real_estate, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: RealEstateWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
