defmodule Erss.Repo.Migrations.LanguageTag do
  use Ecto.Migration

  import Ecto.Query
  import Ecto.Changeset
  alias Erss.Repo

  def up do
    drop_if_exists(unique_index(:tag, [:url, :name]))

    alter table(:fic) do
      add(:language_id, references(:tag))
    end

    flush()

    for fic <- Repo.all(Erss.Fic) |> Repo.preload(:language) do
      lang = from(f in "fic", select: f.language, where: f.id == ^fic.id) |> Repo.one()
      tag = Erss.Tag.get_or_insert(%{name: lang, url: "#"})
      change(fic, %{}) |> put_assoc(:language, tag) |> Repo.update!()
    end

    flush()

    alter table(:fic) do
      remove(:language)
    end
  end
end
