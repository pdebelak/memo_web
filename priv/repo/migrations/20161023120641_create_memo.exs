defmodule MemoWeb.Repo.Migrations.CreateMemo do
  use Ecto.Migration

  def change do
    create table(:memos) do
      add :title, :string
      add :body, :text
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:memos, [:user_id])

  end
end
