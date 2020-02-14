defmodule Erss.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema

  schema "users" do
    pow_user_fields()

    has_many(:reading_lists, Erss.ReadingList)

    timestamps()
  end
end
