defmodule MemoWeb.MemoViewTest do
  use MemoWeb.ConnCase, async: true

  alias MemoWeb.MemoView

  test "user_name with memo" do
    memo = %MemoWeb.Memo{user: %MemoWeb.User{email: "test@example.com"}}
    assert MemoView.user_name(memo) == "test"
  end

  test "user_name with user" do
    user = %MemoWeb.User{email: "test@example.com"}
    assert MemoView.user_name(user) == "test"
  end

  test "memo_body with markdown turns into html" do
    memo = %MemoWeb.Memo{body: "body **text**"}
    assert MemoView.memo_body(memo) =~ "body <strong>text</strong>"
  end

  test "memo_body with html escapes it" do
    memo = %MemoWeb.Memo{body: "body <a>text</a>"}
    assert MemoView.memo_body(memo) =~ "body &lt;a&gt;text&lt;/a&gt;"
  end
end
