# lib/real_estate_web/controllers/session_controller.ex
defmodule RealEstateWeb.SessionController do
  use RealEstateWeb, :controller
  alias RealEstate.Accounts

  def new(conn, _params) do
    render(conn, :new)
  end

  def create(conn, params) do
    params = params["session"] || params

    %{"email" => email, "password" => password} = params

    case Accounts.authenticate(email, password) do
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)
        |> put_flash(:info, "Welcome back, #{user.full_name || user.email}!")
        |> redirect(to: dashboard_path(user))

      {:error, _} ->
        conn
        |> put_flash(:error, "Invalid email or password.")
        |> render(:new)
    end
  end

  def delete(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> put_flash(:info, "You have been logged out.")
    |> redirect(to: ~p"/")
  end

  # Redirect each role to their own dashboard after login
  defp dashboard_path(user) do
    case user.role do
      "admin" -> ~p"/admin"
      "agent" -> ~p"/agent"
      "owner" -> ~p"/owner"
      "buyer" -> ~p"/buyer"
      _ -> ~p"/"
    end
  end
end
