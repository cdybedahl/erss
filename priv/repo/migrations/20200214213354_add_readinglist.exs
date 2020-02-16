defmodule Erss.Repo.Migrations.AddReadinglist do
  use Ecto.Migration

  def change do
    create table(:reading_list) do
      add(:fic_id, references(:fic), null: false)
      add(:user_id, references(:users), null: false)
      add(:read, :bool, default: false)

      timestamps()
    end

    create index(:reading_list, :fic_id)
    create index(:reading_list, :user_id)
    create unique_index(:reading_list, [:fic_id, :user_id])
  end
end
