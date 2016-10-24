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
        |> put_flash(:info, "Signed in!")
        |> redirect(to: memo_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Your email or password were incorrect. Please try again.")
        |> render("new.html", changeset: changeset)
    end
  end

  def delete(conn, _params) do
    conn
    |> Guardian.Plug.sign_out()
    |> put_flash(:info, "Logged out")
    |> redirect(to: memo_path(conn, :index))
  end
end
