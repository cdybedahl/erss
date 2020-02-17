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
      INSERT INTO rating (user_id, tag_id, rating, inserted_at, updated_at) SELECT 1, id, rating, NOW(), NOW() FROM tag;
      DROP VIEW fic_ratings;
      CREATE OR REPLACE VIEW fic_user_ratings AS
      SELECT tf.fic_id,
       r.user_id,
       sum(r.rating) AS total
      FROM tag_fic AS tf
      JOIN rating AS r ON tf.tag_id = r.tag_id
      GROUP BY (tf.fic_id,
          r.user_id)
      """,
      ~S"""
      DROP VIEW fic_user_ratings
      """
    )

    flush()

    alter table(:tag) do
      remove :rating, :integer, default: 0
    end
  end
end
