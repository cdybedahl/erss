defmodule ErssWeb.RatingController do
  use ErssWeb, :controller
  import Ecto.Query
  import Ecto.Changeset

  def list(conn, params = %{"id" => id}) do
    source = from(t in Erss.Tag.Rating, where: t.id == ^id, join: f in assoc(t, :fics), select: f)

    conn
    |> put_view(ErssWeb.FicView)
    |> render(
      "index.html",
      ErssWeb.Helper.paged(source, fn p -> Routes.rating_path(conn, :list, id, p) end, params)
    )
  end

  def index(conn, _params) do
    tags =
      from(f in Erss.Tag.Rating, order_by: [desc: f.rating, asc: f.name])
      |> Erss.Repo.all()

    render(conn, "index.html", tags: tags)
  end

  def uprate(conn, %{"id" => id, "amount" => amount}) do
    tag = Erss.Repo.get!(Erss.Tag.Rating, id)

    change(tag, %{rating: tag.rating + String.to_integer(amount)})
    |> Erss.Repo.update!()

    redirect(conn, to: "/rating")
  end

  def downrate(conn, %{"id" => id, "amount" => amount}) do
    tag = Erss.Repo.get!(Erss.Tag.Rating, id)

    change(tag, %{rating: tag.rating - String.to_integer(amount)})
    |> Erss.Repo.update!()

    redirect(conn, to: "/rating")
  end
end
