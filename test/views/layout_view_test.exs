defmodule MemoWeb.LayoutViewTest do
  use MemoWeb.ConnCase, async: true

  alias MemoWeb.LayoutView
  import Phoenix.HTML, only: [safe_to_string: 1]

  test "nav_link is not active when not on that page" do
    link = LayoutView.nav_link(%{request_path: "/other_path"}, "Link text", "/path")
    |> safe_to_string()
    refute String.match? link, ~r/is-active/
  end

  test "nav_link is active when on that page" do
    link = LayoutView.nav_link(%{request_path: "/path"}, "Link text", "/path")
    |> safe_to_string()
    assert String.match? link, ~r/is-active/
  end
end
