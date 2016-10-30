defmodule MemoWeb.UserStorage do
  alias MemoWeb.Repo
  alias MemoWeb.User

  @callback find(integer) :: Ecto.Schema.t | nil | no_return
  @callback save(Ecto.Changeset.t) :: {:ok, Ecto.Schema.t} | {:error, Ecto.Changeset.t}
  @callback by_email(String.t) :: Ecto.Schema.t | nil | no_return

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
