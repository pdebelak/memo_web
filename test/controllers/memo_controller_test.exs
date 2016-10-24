defmodule MemoWeb.MemoControllerTest do
  use MemoWeb.ConnCase

  alias MemoWeb.Memo
  alias MemoWeb.User
  @valid_attrs %{body: "the body", title: "the title"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, memo_path(conn, :index)
    assert html_response(conn, 200) =~ "Write your memos on the web"
  end

  test "renders form for new resources", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = conn
    |> with_current_user(user)
    |> get(memo_path(conn, :new))
    assert html_response(conn, 200) =~ "New memo"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = conn
    |> with_current_user(user)
    |> post(memo_path(conn, :create), memo: @valid_attrs)
    assert redirected_to(conn) == memo_path(conn, :index)
    memo = Repo.get_by(Memo, title: @valid_attrs[:title])
    assert memo
    assert user.id == memo.user_id
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = conn
    |> with_current_user(user)
    |> post(memo_path(conn, :create), memo: @invalid_attrs)
    assert html_response(conn, 200) =~ "New memo"
  end

  test "shows chosen resource", %{conn: conn} do
    user = Repo.insert! %User{email: "hello"}
    memo = Repo.insert! %Memo{user: user, body: "The *body*"}
    conn = get conn, memo_path(conn, :show, memo)
    assert html_response(conn, 200) =~ "The <em>body</em>"
  end

  test "escapes explicit html", %{conn: conn} do
    user = Repo.insert! %User{email: "hello"}
    memo = Repo.insert! %Memo{user: user, body: "The <em>body</em>"}
    conn = get conn, memo_path(conn, :show, memo)
    assert html_response(conn, 200) =~ "The &lt;em&gt;body&lt;/em&gt;"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, memo_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    user = Repo.insert! %User{}
    memo = Repo.insert! %Memo{user: user}
    conn = conn
    |> with_current_user(user)
    |> get(memo_path(conn, :edit, memo))
    assert html_response(conn, 200) =~ "Edit memo"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    user = Repo.insert! %User{}
    memo = Repo.insert! %Memo{user: user}
    conn = conn
    |> with_current_user(user)
    |> put(memo_path(conn, :update, memo), memo: @valid_attrs)
    assert redirected_to(conn) == memo_path(conn, :show, memo)
    assert Repo.get_by(Memo, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    user = Repo.insert! %User{}
    memo = Repo.insert! %Memo{user: user}
    conn = conn
    |> with_current_user(user)
    |> put(memo_path(conn, :update, memo), memo: @invalid_attrs)
    assert html_response(conn, 200) =~ "Edit memo"
  end

  test "deletes chosen resource", %{conn: conn} do
    user = Repo.insert! %User{}
    memo = Repo.insert! %Memo{user: user}
    conn = conn
    |> with_current_user(user)
    |> delete(memo_path(conn, :delete, memo))
    assert redirected_to(conn) == memo_path(conn, :index)
    refute Repo.get(Memo, memo.id)
  end
end
