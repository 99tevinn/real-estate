defmodule RealEstateWeb.Plugs.RequireRole do
  import Plug.Conn
  import Phoenix.Controller

  def init(roles), do: roles

  def call(conn, required_role) do
    user = conn.assigns[:current_user]
    allowed_roles = Enum.map(required_role, &to_string/1)

    if user && user.role in allowed_roles do
      conn
    else
      conn
      |> put_flash(:error, "Access Denied")
      |> redirect(to: "/")
      |> halt()
    end
  end
end
