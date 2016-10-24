defmodule MemoWeb.MemoView do
  use MemoWeb.Web, :view

  def user_name(%MemoWeb.Memo{user: user}) do
    MemoWeb.User.name(user)
  end

  def user_name(user = %MemoWeb.User{}) do
    MemoWeb.User.name(user)
  end

  def memo_body(memo) do
    {:safe, escaped} = memo.body
    |> html_escape()
    Earmark.to_html(escaped)
  end

  def paginate(conn, paginator, opts \\ []) do
    opts = Kerosene.Paginator.build_options(opts)

    conn
    |> Kerosene.Paginator.paginate(paginator, opts)
    |> render_page_list(opts)
  end

  defp render_page_list([_item], _opts), do: nil
  defp render_page_list(page_list, _opts) do
    content_tag :nav, class: "pagination" do
      content_tag :ul do
        for {label, _page, url, current} <- page_list do
          content_tag :li do
            link label, to: url, class: build_html_class(current)
          end
        end
      end
    end
  end

  defp build_html_class(true), do: "button is-primary"
  defp build_html_class(false), do: "button"
end
