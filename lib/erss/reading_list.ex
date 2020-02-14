defmodule Erss.ReadingList do
  use Ecto.Schema

  schema "reading_list" do
    field(:read, :boolean, default: false)
    belongs_to :user, Erss.Users.User
    belongs_to :fic, Erss.Fic
  end
end
