defmodule MemoWeb.LayoutView do
  use MemoWeb.Web, :view

  def nav_link(conn, text, path) do
    link text, to: path, class: nav_link_class(conn.request_path, path)
  end

  defp nav_link_class(path, path), do: "nav-item is-active"
  defp nav_link_class(_, _), do: "nav-item"
end
