defmodule Erss.Fic do
  use Ecto.Schema

  alias Erss.Repo
  import Ecto.Changeset

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

    belongs_to(:author, Erss.Tag.Author)
    belongs_to(:rating, Erss.Tag.Rating)

    many_to_many(:additional_tags, Erss.Tag.Additional,
      join_through: "additional_fic",
      unique: true
    )

    many_to_many(:characters, Erss.Tag.Character, join_through: "character_fic", unique: true)
    many_to_many(:categories, Erss.Tag.Category, join_through: "category_fic", unique: true)
    many_to_many(:fandoms, Erss.Tag.Fandom, join_through: "fandom_fic", unique: true)

    many_to_many(:relationships, Erss.Tag.Relationship,
      join_through: "relationship_fic",
      unique: true
    )

    many_to_many(:warnings, Erss.Tag.Warning, join_through: "warning_fic", unique: true)

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
        |> put_assoc(:additional_tags, Erss.Tag.Additional.get_tagset(fic.additional_tags))
        |> put_assoc(:characters, Erss.Tag.Character.get_tagset(fic.characters))
        |> put_assoc(:categories, Erss.Tag.Category.get_tagset(fic.categories))
        |> put_assoc(:fandoms, Erss.Tag.Fandom.get_tagset(fic.fandoms))
        |> put_assoc(:relationships, Erss.Tag.Relationship.get_tagset(fic.relationships))
        |> put_assoc(:warnings, Erss.Tag.Warning.get_tagset(fic.warnings))
        |> put_assoc(:author, Erss.Tag.Author.get_or_insert(fic.author))
        |> put_assoc(:rating, Erss.Tag.Rating.get_or_insert(fic.rating))
        |> Erss.Repo.insert!()

      f ->
        f
    end
  end

  def total_rating(fic) do
    f =
      fic
      |> Repo.preload([
        :additional_tags,
        :author,
        :categories,
        :characters,
        :fandoms,
        :rating,
        :relationships,
        :warnings
      ])

    sum = Enum.concat([
      f.additional_tags,
      [f.author],
      f.categories,
      f.characters,
      f.characters,
      f.fandoms,
      [f.rating],
      f.relationships,
      f.warnings
    ])
    |> Enum.map(fn t -> t.rating end)
    |> Enum.reduce(0, fn acc, t -> acc + t end)

    if f.words < 1000 do
      sum - 2
    else
      sum
    end
  end

  def rating_class(fic = %{:total => total}) when total < 0 do
    Map.put(fic, :class, "bad")
  end

  def rating_class(fic = %{:total => total}) when total > 4 do
    Map.put(fic, :class, "good")
  end

  def rating_class(fic) do
    Map.put(fic, :class, "neutral")
  end
end
