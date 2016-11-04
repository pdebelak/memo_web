defmodule MemoWeb.SessionControllerTest do
  use MemoWeb.ConnCase, async: true

  alias MemoWeb.User
  alias MemoWeb.Users.Authentication
  @valid_attrs %{email: "test@example.com", password: "password", password_confirmation: "password"}
  @valid_login %{email: "test@example.com", password: "password"}

  test "renders form for login", %{conn: conn} do
    conn = get conn, session_path(conn, :new)
    assert html_response(conn, 200) =~ "Login"
  end

  test "redirects home when logged in", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = conn
    |> with_current_user(user)
    |> get(session_path(conn, :new))
    assert redirected_to(conn) == memo_path(conn, :index)
    assert get_flash(conn, :error) == "Already logged in"
  end

  test "signs in and redirects when data is valid", %{conn: conn} do
    Repo.insert! User.changeset(%User{}, @valid_attrs)
    conn = post conn, session_path(conn, :create), user: @valid_login
    assert redirected_to(conn) == memo_path(conn, :index)
    assert @valid_attrs[:email] == Authentication.current_user(conn).email
  end

  test "does not login and renders errors when data is invalid", %{conn: conn} do
    Repo.insert! User.changeset(%User{}, @valid_attrs)
    conn = post conn, session_path(conn, :create), user: %{ email: "test@example.com", password: "psasword" }
    assert html_response(conn, 200) =~ "Login"
    refute Authentication.current_user(conn)
  end

  test "logs out for delete", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = conn
    |> with_current_user(user)
    |> delete(session_path(conn, :delete))
    refute Authentication.current_user(conn)
  end

  test "renders 401 for delete if not logged in", %{conn: conn} do
    conn = delete conn, session_path(conn, :delete)
    assert html_response(conn, 401) =~ "Not authorized"
  end
end
