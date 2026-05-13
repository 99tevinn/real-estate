defmodule RealEstateWeb.PasswordResetController do
  use RealEstateWeb, :controller

  alias RealEstate.Accounts
  alias RealEstate.Accounts.User

  def new(conn, _params) do
    render(conn, :new)
  end

  def create(conn, %{"email" => email}) do
    # 1. Fetch the user by email from the database
    case Accounts.get_user_by_email(email) do
      nil ->
        conn
        |> put_flash(:info, "If an account with that email exists, a reset link has been sent.")
        |> redirect(to: ~p"/password_reset/new")

      %User{} = user ->
        case Accounts.create_password_reset_token(user) do
          {:ok, updated_user} ->
            # 3. Generate the URL using the UPDATED user (token is now present)
            reset_url = url(conn, ~p"/password_reset/#{updated_user.reset_password_token}")

            # 4. Send the email using the updated user data
            RealEstate.Mailer.Notifier.send_password_reset(updated_user, reset_url)

            conn
            |> put_flash(
              :info,
              "If an account with that email exists, a reset link has been sent."
            )
            |> redirect(to: ~p"/login")

          {:error, _changeset} ->
            # Handle potential database update failures
            conn
            |> put_flash(:error, "Something went wrong. Please try again.")
            |> redirect(to: ~p"/password_reset/new")
        end
    end
  end

  def edit(conn, %{"token" => token}) do
    case Accounts.get_user_by_reset_token(token) do
      nil ->
        conn
        |> put_flash(:error, "Invalid or expired reset link.")
        |> redirect(to: ~p"/login")

      user ->
        if Accounts.token_valid?(user) do
          render(conn, :edit, token: token)
        else
          conn
          |> put_flash(:error, "Reset link has expired. Please request a new one.")
          |> redirect(to: ~p"/password_reset/new")
        end
    end
  end

  def update(conn, %{"token" => token, "password" => password}) do
    case Accounts.get_user_by_reset_token(token) do
      nil ->
        conn
        |> put_flash(:error, "Invalid or expired reset link.")
        |> redirect(to: ~p"/login")

      user ->
        case Accounts.reset_password(user, %{"password" => password}) do
          {:ok, _} ->
            conn
            |> put_flash(:info, "Password reset successfully. Please log in.")
            |> redirect(to: ~p"/login")

          {:error, _} ->
            conn
            |> put_flash(:error, "Could not reset password.")
            |> render(:edit, token: token)
        end
    end
  end
end
