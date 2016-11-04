defmodule MemoWeb.SessionController do
  use MemoWeb.Web, :controller

  alias MemoWeb.Users.Authentication

  plug MemoWeb.AuthenticatedPlug when action in [:delete]
  plug :ensure_logged_out when action in [:new, :create]

  def new(conn, _params) do
    changeset = Authentication.changeset
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Authentication.authenticate(user_params) do
      {:ok, user} ->
        conn
        |> Authentication.sign_in(user)
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
    |> Authentication.sign_out()
    |> put_flash(:info, "Logged out")
    |> redirect(to: memo_path(conn, :index))
  end

  defp ensure_logged_out(conn, _) do
    if Authentication.current_user(conn) do
      conn
      |> put_flash(:error, "Already logged in")
      |> redirect(to: memo_path(conn, :index))
      |> halt()
    else
      conn
    end
  end
end
