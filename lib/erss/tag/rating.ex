defmodule Erss.Tag.Rating do
  use Ecto.Schema

  alias Erss.Repo

  schema "rating" do
    field(:url, :string, null: false)
    field(:name, :string, null: false)
    field(:rating, :integer)
    # FIXME
    has_many(:fics, Erss.Fic)

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
