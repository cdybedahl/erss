defmodule Erss.Repo.Migrations.LongerStrings do
  use Ecto.Migration

  def change do
    alter table(:additional) do
      modify(:url, :string, size: 1024, from: :string)
      modify(:name, :string, size: 1024, from: :string)
    end
    alter table(:author) do
      modify(:url, :string, size: 1024, from: :string)
      modify(:name, :string, size: 1024, from: :string)
    end
    alter table(:category) do
      modify(:url, :string, size: 1024, from: :string)
      modify(:name, :string, size: 1024, from: :string)
    end
    alter table(:character) do
      modify(:url, :string, size: 1024, from: :string)
      modify(:name, :string, size: 1024, from: :string)
    end
    alter table(:fandom) do
      modify(:url, :string, size: 1024, from: :string)
      modify(:name, :string, size: 1024, from: :string)
    end
    alter table(:rating) do
      modify(:url, :string, size: 1024, from: :string)
      modify(:name, :string, size: 1024, from: :string)
    end
    alter table(:relationship) do
      modify(:url, :string, size: 1024, from: :string)
      modify(:name, :string, size: 1024, from: :string)
    end
    alter table(:warning) do
      modify(:url, :string, size: 1024, from: :string)
      modify(:name, :string, size: 1024, from: :string)
    end
  end
end
