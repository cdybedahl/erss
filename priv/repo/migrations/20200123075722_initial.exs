defmodule Erss.Repo.Migrations.Initial do
  use Ecto.Migration

  def change do
    for name <- [
          "additional",
          "author",
          "category",
          "character",
          "fandom",
          "rating",
          "relationship",
          "warning"
        ] do
      create table(name) do
        add(:url, :string, null: false)
        add(:name, :string, null: false)

        timestamps()
      end

      create(unique_index(name, [:url, :name]))
    end

    create table(:fic) do
      add(:words, :integer)
      add(:chapters, :integer, null: false, default: 1)
      add(:chapter_limit, :integer, null: true)
      add(:language, :string, null: false)
      add(:link, :string, null: false)
      add(:title, :string, null: false)
      add(:updated, :string, null: false)
      add(:ao3id, :string, null: true, unique: true)

      add(:author_id, references(:author))
      add(:rating_id, references(:rating))

      timestamps()
    end

    create(unique_index(:fic, :ao3id))
    create(unique_index(:fic, :link))

    create table(:additional_fic) do
      add(:additional_id, references(:additional))
      add(:fic_id, references(:fic))
    end

    create table(:author_fic) do
      add(:author_id, references(:author))
      add(:fic_id, references(:fic))
    end

    create table(:category_fic) do
      add(:category_id, references(:category))
      add(:fic_id, references(:fic))
    end

    create table(:character_fic) do
      add(:character_id, references(:character))
      add(:fic_id, references(:fic))
    end

    create table(:fandom_fic) do
      add(:fandom_id, references(:fandom))
      add(:fic_id, references(:fic))
    end

    create table(:rating_fic) do
      add(:rating_id, references(:rating))
      add(:fic_id, references(:fic))
    end

    create table(:relationship_fic) do
      add(:relationship_id, references(:relationship))
      add(:fic_id, references(:fic))
    end

    create table(:warning_fic) do
      add(:warning_id, references(:warning))
      add(:fic_id, references(:fic))
    end
  end
end
