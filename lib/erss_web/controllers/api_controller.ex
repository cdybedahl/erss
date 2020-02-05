defmodule ErssWeb.ApiController do
  use ErssWeb, :controller

  alias Erss.Repo

  @types %{
    "rating" => Erss.Tag.Rating,
    "fandom" => Erss.Tag.Fandom,
    "additional" => Erss.Tag.Additional,
    "author" => Erss.Tag.Author,
    "category" => Erss.Tag.Category,
    "character" => Erss.Tag.Character,
    "relationship" => Erss.Tag.Relationship,
    "warning" => Erss.Tag.Relationship
  }

  def tagrating(conn, %{"type" => type, "id" => id, "direction" => direction, "amount" => amount}) do
    tag = Repo.get!(Map.get(@types, type), id)
    amount = String.to_integer(amount)

    change =
      case direction do
        "uprate" ->
          Ecto.Changeset.change(tag, %{rating: tag.rating + amount})

        "downrate" ->
          Ecto.Changeset.change(tag, %{rating: tag.rating - amount})
      end

    tag = Repo.update!(change, returning: true)

    render(conn, "tag.json", tag: tag)
  end
end
