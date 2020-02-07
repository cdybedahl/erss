defmodule Erss.Repo.Migrations.AddViews do
  use Ecto.Migration

  def change do
    execute(
      ~S"""
      CREATE OR REPLACE VIEW tag_fic AS TABLE fandom_fic
      UNION TABLE additional_fic
      UNION TABLE category_fic
      UNION TABLE character_fic
      UNION TABLE relationship_fic
      UNION TABLE warning_fic
      UNION
      SELECT id as fic_id,
         rating_id as tag_id
      FROM fic
      UNION
      SELECT id as fic_id,
         author_id as tag_id
      FROM fic
      """,
      ~S[DROP VIEW tag_fic]
    )

    execute(
      ~S"""
      create or replace view fic_ratings as
      select fic.id as fic_id,
         sum(tag.rating) as total
      from tag_fic,
       tag,
       fic
      where fic_id = fic.id
      and tag_fic.tag_id = tag.id
      group by fic.id;
      """,
      ~S[DROP VIEW fic_ratings]
    )
  end
end
