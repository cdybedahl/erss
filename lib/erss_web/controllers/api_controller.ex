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
      cond do
        String.length(term) < 2 ->
          []

        true ->
          from(t in Erss.Tag, where: like(t.name, ^search), order_by: [desc: t.name], limit: 200)
          |> Repo.all()
      end

    render(conn, "tags.json", tags: tags)
  end

  def set_read(conn, %{"ficid" => ficid, "state" => state}) do
    fic = Repo.get!(Erss.Fic, ficid)
    user = conn.assigns.current_user

    state =
      case state do
        "true" ->
          true

        _ ->
          false
      end

    Erss.ReadingList.set_read(fic, user, state)

    render(conn, "set_read.json", state: Erss.ReadingList.is_read(fic, user))
  end
end
