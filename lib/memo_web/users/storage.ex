defmodule MemoWeb.Users.Storage do
  alias MemoWeb.Repo
  alias MemoWeb.User

  @spec find(integer) :: Ecto.Schema.t | nil | no_return
  def find(id) do
    Repo.get!(User, id)
  end

  @spec save(Ecto.Changeset.t) :: {:ok, Ecto.Schema.t} | {:error, Ecto.Changeset.t}
  def save(changeset) do
    Repo.insert_or_update(changeset)
  end

  @spec by_email(String.t) :: Ecto.Schema.t | nil | no_return
  def by_email(email) do
    Repo.get_by(User, email: email)
  end
end
