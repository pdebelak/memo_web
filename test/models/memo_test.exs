defmodule MemoWeb.MemoTest do
  use MemoWeb.ModelCase

  alias MemoWeb.Memo

  @valid_attrs %{body: "some content", title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Memo.changeset(%Memo{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Memo.changeset(%Memo{}, @invalid_attrs)
    refute changeset.valid?
  end
end
