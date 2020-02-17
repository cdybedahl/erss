defmodule Erss.Rating do
  use Ecto.Schema

  schema "rating" do
    field(:rating, :integer, default: 0)

    belongs_to :user, Erss.Users.User
    belongs_to :tag, Erss.Tag

    timestamps()
  end
end
