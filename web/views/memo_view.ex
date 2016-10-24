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
end
