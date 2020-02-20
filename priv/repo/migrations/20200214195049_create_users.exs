defmodule Erss.Repo.Migrations.CreateUsers do
  use Ecto.Migration
  alias Erss.Users.User

  def change do
    create table(:users) do
      add :email, :string, null: false
      add :password_hash, :string

      timestamps()
    end

    create unique_index(:users, [:email])

    flush()

    User.changeset(%User{}, %{
      email: "calle@dybedahl.se",
      password: "citronfromage",
      password_confirmation: "citronfromage"
    })
    |> Erss.Repo.insert_or_update!()
  end
end
