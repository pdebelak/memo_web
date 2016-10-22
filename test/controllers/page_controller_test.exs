defmodule MemoWeb.PageControllerTest do
  use MemoWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "MemoWeb"
  end
end
