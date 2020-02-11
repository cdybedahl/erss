defmodule Erss.Tag do
  use Ecto.Schema

  alias Erss.Repo

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
end
