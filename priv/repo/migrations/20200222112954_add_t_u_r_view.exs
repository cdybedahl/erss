defmodule Erss.Repo.Migrations.AddTURView do
  use Ecto.Migration

  def change do
    execute(
      ~S"""
      CREATE OR REPLACE VIEW tag_user_rating AS
      SELECT i.tag_id AS tag_id,
       i.user_id AS user_id,
       COALESCE(r.rating,0) AS rating
      FROM
      (SELECT tag.id AS tag_id,
            users.id AS user_id
      FROM tag
      JOIN users ON TRUE) AS i
      LEFT JOIN rating AS r ON r.tag_id = i.tag_id
      AND r.user_id = i.user_id
      """,
      ~S"DROP VIEW tag_user_rating"
    )
  end
end
