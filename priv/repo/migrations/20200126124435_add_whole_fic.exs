defmodule Erss.Repo.Migrations.AddWholeFic do
  use Ecto.Migration

  def change do
    alter table(:fic) do
      add(:raw, :text, default: "")
    end
  end
end
