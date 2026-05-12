defmodule RealEstateWeb.Plugs.LoadCurrentUser do
  import Plug.Conn
  alias RealEstate.Accounts

  def init(opts), do: opts

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)

    if user_id do
      case Accounts.get_user(user_id) do
        nil -> conn
        user -> assign(conn, :current_user, user)
      end
    else
      conn
    end
  end
end
