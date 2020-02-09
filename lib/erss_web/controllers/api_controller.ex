defmodule ErssWeb.ApiController do
  use ErssWeb, :controller

  alias Erss.Repo
  import Ecto.Changeset

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
end
