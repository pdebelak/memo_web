defmodule MemoWeb.MemoController do
  use MemoWeb.Web, :controller

  alias MemoWeb.AuthenticatedPlug
  alias MemoWeb.Memo

  plug AuthenticatedPlug when action in [:new, :create, :edit, :update, :delete]

  def index(conn, params) do
    pagination = Memo
    |> preload(:user)
    |> Repo.paginate(params)
    render(conn, "index.html", memos: pagination.entries, page_number: pagination.page_number, total_pages: pagination.total_pages)
  end

  def new(conn, _params) do
    changeset = Memo.changeset(%Memo{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"memo" => memo_params}) do
    changeset = Memo.changeset(%Memo{user: current_user(conn)}, memo_params)

    case Repo.insert(changeset) do
      {:ok, _memo} ->
        conn
        |> put_flash(:info, "Memo created successfully.")
        |> redirect(to: memo_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    memo = Memo
    |> preload(:user)
    |> Repo.get!(id)
    render(conn, "show.html", memo: memo)
  end

  def edit(conn, %{"id" => id}) do
    memo = Memo.for_user(id, current_user(conn))
    changeset = Memo.changeset(memo)
    render(conn, "edit.html", memo: memo, changeset: changeset)
  end

  def update(conn, %{"id" => id, "memo" => memo_params}) do
    memo = Memo.for_user(id, current_user(conn))
    changeset = Memo.changeset(memo, memo_params)

    case Repo.update(changeset) do
      {:ok, memo} ->
        conn
        |> put_flash(:info, "Memo updated successfully.")
        |> redirect(to: memo_path(conn, :show, memo))
      {:error, changeset} ->
        render(conn, "edit.html", memo: memo, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    memo = Memo.for_user(id, current_user(conn))

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(memo)

    conn
    |> put_flash(:info, "Memo deleted successfully.")
    |> redirect(to: memo_path(conn, :index))
  end
end
