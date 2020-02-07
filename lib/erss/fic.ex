defmodule Erss.Fic do
  use Ecto.Schema

  alias Erss.Repo
  import Ecto.Changeset
  import Ecto.Query

  schema "fic" do
    field(:words, :integer)
    field(:chapters, :integer, null: false, default: 1)
    field(:chapter_limit, :integer, null: true)
    field(:language, :string, null: false)
    field(:link, :string, null: false)
    field(:title, :string, null: false)
    field(:updated, :string, null: false)
    field(:ao3id, :string, null: true)
    field(:raw, :string)

    belongs_to(:author, Erss.Tag)
    belongs_to(:rating, Erss.Tag)

    many_to_many(:additional_tags, Erss.Tag,
      join_through: "additional_fic",
      unique: true
    )

    many_to_many(:characters, Erss.Tag, join_through: "character_fic", unique: true)
    many_to_many(:categories, Erss.Tag, join_through: "category_fic", unique: true)
    many_to_many(:fandoms, Erss.Tag, join_through: "fandom_fic", unique: true)

    many_to_many(:relationships, Erss.Tag,
      join_through: "relationship_fic",
      unique: true
    )

    many_to_many(:warnings, Erss.Tag, join_through: "warning_fic", unique: true)
    many_to_many(:tags, Erss.Tag, join_through: "tag_fic")

    timestamps()
  end

  def get_or_insert(fic) do
    case Repo.get_by(__MODULE__, ao3id: fic.ao3id, link: fic.link) do
      nil ->
        cast(%__MODULE__{}, fic, [
          :chapter_limit,
          :chapters,
          :language,
          :link,
          :title,
          :words,
          :ao3id,
          :updated,
          :raw
        ])
        |> put_assoc(:additional_tags, Erss.Tag.get_tagset(fic.additional_tags))
        |> put_assoc(:characters, Erss.Tag.get_tagset(fic.characters))
        |> put_assoc(:categories, Erss.Tag.get_tagset(fic.categories))
        |> put_assoc(:fandoms, Erss.Tag.get_tagset(fic.fandoms))
        |> put_assoc(:relationships, Erss.Tag.get_tagset(fic.relationships))
        |> put_assoc(:warnings, Erss.Tag.get_tagset(fic.warnings))
        |> put_assoc(:author, Erss.Tag.get_or_insert(fic.author))
        |> put_assoc(:rating, Erss.Tag.get_or_insert(fic.rating))
        |> Erss.Repo.insert!()

      f ->
        f
    end
  end

  def total_rating(fic) do
    from(t in "fic_ratings", select: t.total, where: t.fic_id == ^fic.id)
    |> Repo.one()
  end

  def all do
    Repo.all(__MODULE__)
  end
end
