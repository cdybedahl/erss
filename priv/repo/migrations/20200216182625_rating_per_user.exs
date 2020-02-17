defmodule Erss.Repo.Migrations.RatingPerUser do
  use Ecto.Migration

  def change do
    create table(:rating) do
      add :rating, :integer, default: 0
      add :tag_id, references(:tag)
      add :user_id, references(:users)

      timestamps()
    end

    create index(:rating, :tag_id)
    create index(:rating, :user_id)
    create unique_index(:rating, [:tag_id, :user_id])

    execute(
      ~S"""
      INSERT INTO rating (user_id, tag_id, rating, inserted_at, updated_at) SELECT 1, id, rating, NOW(), NOW() FROM tag
      """,
      ~S"""
      """
    )
  end
end
