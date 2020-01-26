defmodule Erss.Tag.Character do
  use Ecto.Schema

  alias Erss.Repo

  schema "character" do
    field(:url, :string, null: false)
    field(:name, :string, null: false)
    field(:rating, :integer)
    many_to_many(:fics, Erss.Fic, join_through: "character_fic", unique: true)

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
