defmodule RealEstate.Accounts do
  import Ecto.Query
  alias RealEstate.Repo
  alias RealEstate.Accounts.User

  def get_user(id), do: Repo.get(User, id)

  def get_user!(id), do: Repo.get!(User, id)

  def get_user_by_email(email) do
    Repo.get_by(User, email: email)
  end

  def authenticate(email, password) do
    user = get_user_by_email(email)

    result =
      cond do
        user && !user.active ->
          {:error, :inactive}

        user && Bcrypt.verify_pass(password, user.password_hash) ->
          {:ok, user}

        user ->
          {:error, :wrong_password}

        true ->
          Bcrypt.no_user_verify()
          {:error, :not_found}
      end

    # This will tell us the result in the terminal
    IO.inspect(result, label: "AUTH_RESULT")
    result
  end

  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def register_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def list_all_users do
    User
    |> order_by([u], desc: u.inserted_at)
    |> Repo.all()
  end

  def list_recent_users(limit) do
    User
    |> order_by([u], desc: u.inserted_at)
    |> limit(^limit)
    |> Repo.all()
  end

  def count_users, do: Repo.aggregate(User, :count)

  def update_user(%User{} = user, attrs) do
    user
    |> User.admin_changeset(attrs)
    |> Repo.update()
  end

  def deactivate_user(%User{} = user) do
    user
    |> Ecto.Changeset.change(active: false)
    |> Repo.update()
  end

  def get_user_by_reset_token(token) do
    Repo.get_by(User, reset_password_token: token)
  end

  def create_password_reset_token(%User{} = user) do
    token =
      :crypto.strong_rand_bytes(32) |> Base.url_encode64(padding: false)

    user
    |> Ecto.Changeset.change(
      reset_password_token: token,
      reset_password_sent_at: DateTime.utc_now()
    )
    |> Repo.update()
  end

  def reset_password(%User{} = user, new_password) do
    user
    |> User.password_reset_changeset(%{password: new_password})
    |> Ecto.Changeset.change(reset_password_token: nil, reset_password_sent_at: nil)
    |> Repo.update()
  end

  def token_valid?(%User{reset_password_sent_at: sent_at}) do
    sent_at && DateTime.diff(DateTime.utc_now(), sent_at) < 3600
  end
end
