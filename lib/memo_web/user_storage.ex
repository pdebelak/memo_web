defmodule MemoWeb.UserStorage do
  import Ecto.Query
  alias MemoWeb.Repo
  alias MemoWeb.User

  def find(id) do
    Repo.get!(User, id)
  end

  def save(changeset) do
    Repo.insert_or_update(changeset)
  end

  def by_email(email) do
    Repo.get_by(User, email: email)
  end
end
