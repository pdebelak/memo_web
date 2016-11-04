defmodule MemoWeb.UserControllerTest do
  use MemoWeb.ConnCase, async: true

  alias MemoWeb.User
  alias MemoWeb.Users.Authentication
  @valid_attrs %{email: "test@example.com", password: "password", password_confirmation: "password"}
  @invalid_attrs %{}

  test "renders form for new users", %{conn: conn} do
    conn = get conn, user_path(conn, :new)
    assert html_response(conn, 200) =~ "Register"
  end

  test "creates user and redirects when data is valid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @valid_attrs
    assert redirected_to(conn) == memo_path(conn, :index)
    assert Repo.get_by(User, email: @valid_attrs[:email])
  end

  test "logs in user when data is valid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @valid_attrs
    user = Repo.get_by(User, email: @valid_attrs[:email])
    assert user.id == Authentication.current_user(conn).id
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @invalid_attrs
    assert html_response(conn, 200) =~ "Register"
  end

  test "does not log in with unsuccessful creation", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @invalid_attrs
    refute Authentication.current_user(conn)
  end

  test "renders form for editing chosen user", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = conn
    |> with_current_user(user)
    |> get(user_path(conn, :edit))
    assert html_response(conn, 200) =~ "Update Settings"
  end

  test "renders 401 for edit if not logged in", %{conn: conn} do
    conn = get conn, user_path(conn, :edit)
    assert html_response(conn, 401) =~ "Not authorized"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = conn
    |> with_current_user(user)
    |> put(user_path(conn, :update), user: @valid_attrs)
    assert redirected_to(conn) == memo_path(conn, :index)
    assert Repo.get_by(User, email: @valid_attrs[:email])
  end

  test "renders 401 for update if not logged in", %{conn: conn} do
    conn = put conn, user_path(conn, :update), user: @valid_attrs
    assert html_response(conn, 401) =~ "Not authorized"
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = conn
    |> with_current_user(user)
    |> put(user_path(conn, :update), user: @invalid_attrs)
    assert html_response(conn, 200) =~ "Update Settings"
  end
end
