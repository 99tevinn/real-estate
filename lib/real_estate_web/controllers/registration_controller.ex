defmodule RealEstateWeb.RegistrationController do
  use RealEstateWeb, :controller
  alias RealEstate.Accounts
  alias RealEstate.Accounts.User

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)
        |> put_flash(:info, "Account created! Welcome, #{user.full_name || user.email}.")
        |> redirect(to: dashboard_path(user))

      {:error, changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  defp dashboard_path(user) do
    case user.role do
      "admin" -> ~p"/admin"
      "agent" -> ~p"/agent"
      "owner" -> ~p"/owner"
      _       -> ~p"/buyer"
    end
  end
end
