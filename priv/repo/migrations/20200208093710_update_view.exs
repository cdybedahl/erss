defmodule Erss.Repo.Migrations.UpdateView do
  use Ecto.Migration

  def up do
    execute(~S[DROP VIEW fic_ratings])
    execute(~S[DROP VIEW tag_fic])

    execute(~S"""
    CREATE VIEW tag_fic AS TABLE fandom_fic
    UNION TABLE additional_fic
    UNION TABLE category_fic
    UNION TABLE character_fic
    UNION TABLE relationship_fic
    UNION TABLE warning_fic
    UNION
    SELECT rating_id as tag_id, id as fic_id
    FROM fic
    UNION
    SELECT author_id as tag_id, id as fic_id
    FROM fic
    UNION
    SELECT language_id as tag_id, id as fic_id
    FROM fic
    """)

    execute(~S"""
    create or replace view fic_ratings as
    select fic.id as fic_id,
       sum(tag.rating) as total
    from tag_fic,
     tag,
     fic
    where fic_id = fic.id
    and tag_fic.tag_id = tag.id
    group by fic.id;
    """)
  end
end
