defmodule Erss.Repo.Migrations.AddGrades do
  use Ecto.Migration

  def change do
    alter table(:additional) do
      add(:rating, :integer, default: 0)
    end

    alter table(:author) do
      add(:rating, :integer, default: 0)
    end

    alter table(:category) do
      add(:rating, :integer, default: 0)
    end

    alter table(:character) do
      add(:rating, :integer, default: 0)
    end

    alter table(:fandom) do
      add(:rating, :integer, default: 0)
    end

    alter table(:rating) do
      add(:rating, :integer, default: 0)
    end

    alter table(:relationship) do
      add(:rating, :integer, default: 0)
    end

    alter table(:warning) do
      add(:rating, :integer, default: 0)
    end
  end
end
