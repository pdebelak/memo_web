defmodule MemoWeb.MemoView do
  use MemoWeb.Web, :view

  def user_name(memo) do
    MemoWeb.User.name(memo.user)
  end

  def memo_body(memo) do
    {:safe, escaped} = memo.body
    |> html_escape()
    Earmark.to_html(escaped)
  end
end
