defmodule MemoWeb.Memos.Storage do
  import Ecto.Query
  alias MemoWeb.Repo
  alias MemoWeb.Memo

  @spec find(integer) :: Ecto.Schema.t | nil | no_return
  def find(id) do
    Memo
    |> preload(:user)
    |> Repo.get!(id)
  end

  @spec for_user(integer, Ecto.Schema.t) :: Ecto.Schema.t | nil | no_return
  def for_user(id, user) do
    Repo.get_by!(Memo, id: id, user_id: user.id)
  end

  @spec save(Ecto.Changeset.t) :: {:ok, Ecto.Schema.t} | {:error, Ecto.Changeset.t}
  def save(changeset) do
    Repo.insert_or_update(changeset)
  end

  @spec all_paginated(integer | nil) :: { [Ecto.Schema.t], struct }
  @spec all_paginated(integer, integer | nil) :: { [Ecto.Schema.t], struct }
  def all_paginated(page) do
    paginated(Memo, page)
  end
  def all_paginated(user_id, page) do
    Memo
    |> where(user_id: ^user_id)
    |> paginated(page)
  end

  @spec all_paginated(Ecto.Query.t, integer | nil) :: { [Ecto.Schema.t], struct }
  defp paginated(scope, page) do
    scope
    |> preload(:user)
    |> order_by(desc: :inserted_at)
    |> Repo.paginate(%{"page" => page})
  end

  @spec delete(Ecto.Schema.t) ::  Ecto.Schema.t | no_return
  def delete(memo) do
    Repo.delete!(memo)
  end
end
