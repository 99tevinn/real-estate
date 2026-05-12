defmodule RealEstateWeb.Admin.UserController do
  use RealEstateWeb, :controller
  alias RealEstate.Accounts

  def index(conn, _params) do
    users = Accounts.list_all_users()
    render(conn, :index, users: users)
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, :show, user: user)
  end

  def edit(conn, %{"id" => id}) do
    user      = Accounts.get_user!(id)
    changeset = Accounts.change_user(user)
    render(conn, :edit, user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => params}) do
    user = Accounts.get_user!(id)

    case Accounts.update_user(user, params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: ~p"/admin/users")

      {:error, changeset} ->
        render(conn, :edit, user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    if user.id == conn.assigns.current_user.id do
      conn
      |> put_flash(:error, "You cannot deactivate your own account.")
      |> redirect(to: ~p"/admin/users")
    else
      {:ok, _} = Accounts.deactivate_user(user)

      conn
      |> put_flash(:info, "User deactivated.")
      |> redirect(to: ~p"/admin/users")
    end
  end
end
