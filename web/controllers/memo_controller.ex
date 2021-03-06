defmodule MemoWeb.MemoController do
  use MemoWeb.Web, :controller

  alias MemoWeb.Memo
  alias MemoWeb.Memos.Storage

  plug MemoWeb.AuthenticatedPlug when action in [:new, :create, :edit, :update, :delete]

  def index(conn, params = %{"user_id" => user_id}) do
    {memos, kerosene} = Storage.all_paginated(user_id, params["page"])
    render(conn, "index.html", memos: memos, user: MemoWeb.Users.Storage.find(user_id), kerosene: kerosene)
  end
  def index(conn, params) do
    {memos, kerosene} = Storage.all_paginated(params["page"])
    render(conn, "index.html", memos: memos, kerosene: kerosene)
  end

  def new(conn, _params) do
    changeset = Memo.changeset(%Memo{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"memo" => memo_params}) do
    changeset = Memo.changeset(%Memo{user: current_user(conn)}, memo_params)

    case Storage.save(changeset) do
      {:ok, _memo} ->
        conn
        |> put_flash(:info, "Memo created successfully.")
        |> redirect(to: memo_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Oops, something went wrong! Please check the errors below.")
        |> render("new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    memo = Storage.find(id)
    render(conn, "show.html", memo: memo)
  end

  def edit(conn, %{"id" => id}) do
    memo = Storage.for_user(id, current_user(conn))
    changeset = Memo.changeset(memo)
    render(conn, "edit.html", memo: memo, changeset: changeset)
  end

  def update(conn, %{"id" => id, "memo" => memo_params}) do
    memo = Storage.for_user(id, current_user(conn))
    changeset = Memo.changeset(memo, memo_params)

    case Storage.save(changeset) do
      {:ok, memo} ->
        conn
        |> put_flash(:info, "Memo updated successfully.")
        |> redirect(to: memo_path(conn, :show, memo))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Oops, something went wrong! Please check the errors below.")
        |> render("edit.html", memo: memo, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    memo = Storage.for_user(id, current_user(conn))
    Storage.delete(memo)
    conn
    |> put_flash(:info, "Memo deleted successfully.")
    |> redirect(to: memo_path(conn, :index))
  end
end
