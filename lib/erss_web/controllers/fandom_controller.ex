defmodule ErssWeb.FandomController do
  use ErssWeb, :controller
  import Ecto.Query

  def index(conn, _params) do
    tags =
      from(f in Erss.Tag.Fandom, order_by: f.name)
      |> Erss.Repo.all()

    render(conn, "index.html", tags: tags)
  end

  def uprate(conn, params) do
    render(conn, "tmp.html", params: params)
  end

  def downrate(conn, params) do
    render(conn, "tmp.html", params: params)
  end
end
