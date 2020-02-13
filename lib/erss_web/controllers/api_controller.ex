defmodule ErssWeb.ApiController do
  use ErssWeb, :controller

  alias Erss.Repo
  import Ecto.Changeset
  import Ecto.Query

  def up(conn, %{"id" => id}) do
    change(conn, id, 1)
  end

  def down(conn, %{"id" => id}) do
    change(conn, id, -1)
  end

  def change(conn, id, amount) do
    tag = Repo.get(Erss.Tag, id)

    tag =
      change(tag, rating: tag.rating + amount)
      |> Repo.update!()

    render(conn, "tag.json", tag: tag)
  end

  def find_tag(conn, %{"term" => term}) do
    search = "%" <> term <> "%"

    tags =
      from(t in Erss.Tag, where: like(t.name, ^search), order_by: [desc: t.name], limit: 25)
      |> Repo.all()

    render(conn, "tags.json", tags: tags)
  end
end
