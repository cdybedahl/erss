defmodule Erss.Repo.Migrations.Initial do
  use Ecto.Migration

  @many_to_many_tables [
    :additional_fic,
    :category_fic,
    :character_fic,
    :fandom_fic,
    :relationship_fic,
    :warning_fic
  ]

  def change do
    create table(:tag) do
      add(:url, :string, null: false, size: 2048)
      add(:name, :string, null: false, size: 2048)
      add(:rating, :integer, default: 0)

      timestamps()
    end

    create(unique_index(:tag, [:url, :name]))

    create table(:fic) do
      add(:words, :integer)
      add(:chapters, :integer, null: false, default: 1)
      add(:chapter_limit, :integer, null: true)
      add(:language, :string, null: false)
      add(:link, :string, null: false)
      add(:title, :string, null: false, size: 2048)
      add(:updated, :string, null: false)
      add(:ao3id, :string, null: true, unique: true)
      add(:raw, :text)

      add(:author_id, references(:tag))
      add(:rating_id, references(:tag))

      timestamps()
    end

    create(unique_index(:fic, :ao3id))
    create(unique_index(:fic, :link))

    for name <- @many_to_many_tables do
      create table(name, primary_key: false) do
        add(:tag_id, references(:tag))
        add(:fic_id, references(:fic))
      end

      create(index(name, [:tag_id]))
      create(index(name, [:fic_id]))
    end
  end
end
