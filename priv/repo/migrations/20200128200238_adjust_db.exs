defmodule Erss.Repo.Migrations.AdjustDb do
  use Ecto.Migration

  def change do
    drop table(:rating_fic)
    drop table(:author_fic)

    create index(:additional_fic, [:fic_id, :additional_id], unique: true)
    create index(:category_fic, [:fic_id, :category_id], unique: true)
    create index(:character_fic, [:fic_id, :character_id], unique: true)
    create index(:fandom_fic, [:fic_id, :fandom_id], unique: true)
    create index(:relationship_fic, [:fic_id, :relationship_id], unique: true)
    create index(:warning_fic, [:fic_id, :warning_id], unique: true)

    create index(:fic, :rating_id)
    create index(:fic, :author_id)
  end
end
