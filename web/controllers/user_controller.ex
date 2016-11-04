defmodule MemoWeb.UserController do
  use MemoWeb.Web, :controller

  alias MemoWeb.User
  alias MemoWeb.Users.Storage
  alias MemoWeb.Users.Authentication

  plug MemoWeb.AuthenticatedPlug when action in [:edit, :update]

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    case Storage.save(changeset) do
      {:ok, user} ->
        conn
        |> Authentication.sign_in(user)
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: memo_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Oops, something went wrong! Please check the errors below.")
        |> render("new.html", changeset: changeset)
    end
  end

  def edit(conn, _params) do
    user = current_user(conn)
    changeset = User.changeset(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"user" => user_params}) do
    user = current_user(conn)
    changeset = User.changeset(user, user_params)

    case Storage.save(changeset) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: memo_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Oops, something went wrong! Please check the errors below.")
        |> render("edit.html", user: user, changeset: changeset)
    end
  end
end
