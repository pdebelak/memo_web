defmodule MemoWeb.MemoStorage do
  import Ecto.Query
  alias MemoWeb.Repo
  alias MemoWeb.Memo

  @callback find(integer) :: Ecto.Schema.t | nil | no_return
  @callback for_user(integer, Ecto.Schema.t) :: Ecto.Schema.t | nil | no_return
  @callback save(Ecto.Changeset.t) :: {:ok, Ecto.Schema.t} | {:error, Ecto.Changeset.t}
  @callback all_paginated(integer) :: { [Ecto.Schema.t], struct }
  @callback all_paginated_for_user_id(integer, integer | nil) :: { [Ecto.Schema.t], struct }
  @callback delete(Ecto.Schema.t) ::  Ecto.Schema.t | no_return

  def find(id) do
    Memo
    |> preload(:user)
    |> Repo.get!(id)
  end

  def for_user(id, user) do
    Repo.get_by!(Memo, id: id, user_id: user.id)
  end

  def save(changeset) do
    Repo.insert_or_update(changeset)
  end

  def all_paginated_for_user_id(user_id, page) do
    Memo
    |> where(user_id: ^user_id)
    |> paginated(page)
  end

  def all_paginated(page) do
    paginated(Memo, page)
  end

  defp paginated(scope, page) do
    scope
    |> preload(:user)
    |> order_by(desc: :inserted_at)
    |> Repo.paginate(%{"page" => page})
  end

  def delete(memo) do
    Repo.delete!(memo)
  end
end
