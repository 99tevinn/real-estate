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
end
