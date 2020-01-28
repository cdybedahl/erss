defmodule ErssWeb.AdditionalController do
  use ErssWeb, :controller
  import Ecto.Query
  import Ecto.Changeset

  def index(conn, _params) do
    tags =
      from(f in Erss.Tag.Additional, order_by: f.name)
      |> Erss.Repo.all()

    render(conn, "index.html", tags: tags)
  end

  def uprate(conn, %{"id" => id, "amount" => amount}) do
    tag = Erss.Repo.get!(Erss.Tag.Additional, id)

    change(tag, %{rating: tag.rating + String.to_integer(amount)})
    |> Erss.Repo.update!()

    redirect(conn, to: "/additional")
  end

  def downrate(conn, %{"id" => id, "amount" => amount}) do
    tag = Erss.Repo.get!(Erss.Tag.Additional, id)

    change(tag, %{rating: tag.rating - String.to_integer(amount)})
    |> Erss.Repo.update!()

    redirect(conn, to: "/additional")
  end
end
