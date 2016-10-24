defmodule MemoWeb.Memo do
  use MemoWeb.Web, :model
  alias MemoWeb.Repo

  schema "memos" do
    field :title, :string
    field :body, :string
    belongs_to :user, MemoWeb.User

    timestamps()
  end

  def for_user(id, user) do
    Repo.get_by!(__MODULE__, id: id, user_id: user.id)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :body])
    |> validate_required([:title, :body])
  end
end
