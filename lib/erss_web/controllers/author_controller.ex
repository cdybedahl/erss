defmodule ErssWeb.AuthorController do
  use ErssWeb, :controller
  import Ecto.Query

  def index(conn, _params) do
    tags =
      from(f in Erss.Tag.Author, order_by: f.name)
      |> Erss.Repo.all()
      |> Enum.map(fn e -> %{id: e.id, name: e.name, url: e.url} end)

    render(conn, "index.html", tags: tags)
  end
end
