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
    user_id = conn.assigns.current_user.id
    id = String.to_integer(id)

    rating =
      case Repo.get_by(Erss.Rating, tag_id: id, user_id: user_id) do
        nil ->
          Repo.insert!(%Erss.Rating{tag_id: id, rating: 0, user_id: user_id})

        r ->
          r
      end
      |> Repo.preload(:tag)

    rating =
      change(rating, rating: rating.rating + amount)
      |> Repo.update!()

    render(conn, "tag.json", tag: rating.tag, rating: rating.rating)
  end

  def find_tag(conn, %{"term" => term}) do
    search = "%" <> term <> "%"

    tags =
      cond do
        String.length(term) < 2 ->
          []

        true ->
          from(t in Erss.Tag, where: ilike(t.name, ^search), order_by: [desc: t.name], limit: 200)
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
