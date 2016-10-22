defmodule MemoWeb.SessionController do
  use MemoWeb.Web, :controller

  alias MemoWeb.User

  plug MemoWeb.AuthenticatedPlug when action in [:delete]

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case User.authenticate(user_params) do
      {:ok, user} ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> redirect(to: page_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def delete(conn, _params) do
    conn
    |> Guardian.Plug.sign_out()
    |> put_flash(:info, "Logged out")
    |> redirect(to: page_path(conn, :index))
  end
end
