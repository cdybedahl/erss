defmodule Erss.Repo.Migrations.MoreIndexes do
  use Ecto.Migration

  def change do
    create index(:fic, :language_id)
    create index(:fic, :author_id)
    create index(:fic, :rating_id)
  end
end
