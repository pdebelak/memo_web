defmodule MemoWeb.UserController do
  use MemoWeb.Web, :controller

  alias MemoWeb.AuthenticatedPlug
  alias MemoWeb.User

  plug AuthenticatedPlug when action in [:edit, :update]

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: memo_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    user = User.find(id)
    if Guardian.Plug.current_resource(conn).id == user.id do
      changeset = User.changeset(user)
      render(conn, "edit.html", user: user, changeset: changeset)
    else
      AuthenticatedPlug.unauthenticated(conn, %{})
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = User.find(id)

    if Guardian.Plug.current_resource(conn).id == user.id do
      changeset = User.changeset(user, user_params)

      case Repo.update(changeset) do
        {:ok, _user} ->
          conn
          |> put_flash(:info, "User updated successfully.")
          |> redirect(to: memo_path(conn, :index))
        {:error, changeset} ->
          render(conn, "edit.html", user: user, changeset: changeset)
      end
    else
      AuthenticatedPlug.unauthenticated(conn, %{})
    end
  end
end
