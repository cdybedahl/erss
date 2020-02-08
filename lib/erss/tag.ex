defmodule Erss.Tag do
  use Ecto.Schema

  alias Erss.Repo
  import Ecto.Query

  schema "tag" do
    field(:url, :string, null: false)
    field(:name, :string, null: false)
    field(:rating, :integer, default: 0)
    many_to_many(:additional_fics, Erss.Fic, join_through: "additional_fic", unique: true)
    many_to_many(:category_fics, Erss.Fic, join_through: "category_fic", unique: true)
    many_to_many(:character_fics, Erss.Fic, join_through: "character_fic", unique: true)
    many_to_many(:fandom_fics, Erss.Fic, join_through: "fandom_fic", unique: true)
    many_to_many(:relationship_fics, Erss.Fic, join_through: "relationship_fic", unique: true)
    many_to_many(:warning_fics, Erss.Fic, join_through: "warning_fic", unique: true)

    has_many(:rating_fics, Erss.Fic, foreign_key: :rating_id)
    has_many(:author_fics, Erss.Fic, foreign_key: :author_id)
    has_many(:language_fics, Erss.Fic, foreign_key: :language_id)

    many_to_many(:fics, Erss.Fic, join_through: "tag_fic")

    timestamps()
  end

  def get_or_insert(%{name: name, url: url}) do
    case Repo.get_by(__MODULE__, name: name, url: url) do
      nil ->
        Repo.insert!(Ecto.Changeset.change(%__MODULE__{}, %{name: name, url: url}))

      t ->
        t
    end
  end

  def get_tagset(list) do
    Enum.map(list, &get_or_insert/1)
  end

  def all_authors do
    from(t in Erss.Tag, join: f in Erss.Fic, on: f.author_id == t.id, select: t, distinct: true)
  end

  def all_authors_with_counts do
    from(t in Erss.Tag,
      join: f in Erss.Fic,
      on: f.author_id == t.id,
      group_by: t.id,
      select: {t, count(t.id)},
      order_by: [desc: count(t.id)]
    )
  end

  def all_ratings do
    from(t in Erss.Tag, join: f in Erss.Fic, on: f.rating_id == t.id, select: t, distinct: true)
  end

  def all_ratings_with_counts do
    from(t in Erss.Tag,
      join: f in Erss.Fic,
      on: f.rating_id == t.id,
      group_by: t.id,
      select: {t, count(t.id)},
      order_by: [desc: count(t.id)]
    )
  end

  def all_languages do
    from(t in Erss.Tag, join: f in Erss.Fic, on: f.language_id == t.id, select: t, distinct: true)
  end

  def all_languages_with_counts do
    from(t in Erss.Tag,
      join: f in Erss.Fic,
      on: f.language_id == t.id,
      group_by: t.id,
      select: {t, count(t.id)},
      order_by: [desc: count(t.id)]
    )
  end

  def all_warnings, do: all_from_table("warning_fic")
  def all_warnings_with_counts, do: all_from_table_with_counts("warning_fic")

  def all_relationships, do: all_from_table("relationship_fic")
  def all_relationships_with_counts, do: all_from_table_with_counts("relationship_fic")

  def all_fandoms, do: all_from_table("fandom_fic")
  def all_fandoms_with_counts, do: all_from_table_with_counts("fandom_fic")

  def all_characters, do: all_from_table("character_fic")
  def all_characters_with_counts, do: all_from_table_with_counts("character_fic")

  def all_categories, do: all_from_table("category_fic")
  def all_categories_with_counts, do: all_from_table_with_counts("category_fic")

  def all_additional_tags, do: all_from_table("additional_fic")
  def all_additional_tags_with_counts, do: all_from_table_with_counts("additional_fic")

  def all_from_table(table) do
    from(t in Erss.Tag, join: wf in ^table, on: wf.tag_id == t.id, distinct: true)
  end

  def all_from_table_with_counts(table) do
    from(t in Erss.Tag,
      join: wf in ^table,
      on: wf.tag_id == t.id,
      group_by: t.id,
      select: {t, count(t.id)},
      order_by: [desc: count(t.id)]
    )
  end
end
