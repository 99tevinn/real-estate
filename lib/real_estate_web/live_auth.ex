defmodule RealEstateWeb.LiveAuth do
  import Phoenix.LiveView
  import Phoenix.Component
  alias RealEstate.Accounts

  def on_mount(:require_admin, _params, session, socket) do
    mount_user(socket, session, ["admin"])
  end

  def on_mount(:require_agent, _params, session, socket) do
    mount_user(socket, session, ["agent"])
  end

  def on_mount(:require_owner, _params, session, socket) do
    mount_user(socket, session, ["owner"])
  end

  def on_mount(:require_buyer, _params, session, socket) do
    mount_user(socket, session, ["buyer"])
  end

  defp mount_user(socket, session, allowed_roles) do
    case Accounts.get_user(session["user_id"]) do
      nil ->
        {:halt, redirect(socket, to: "/login")}

      user ->
        if Enum.member?(allowed_roles, user.role) do
          {:cont, assign_new(socket, :current_user, fn -> user end)}
        else
          {:halt, redirect(socket, to: "/login")}
        end
    end
  end
end
