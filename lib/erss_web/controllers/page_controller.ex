defmodule ErssWeb.PageController do
  use ErssWeb, :controller
  import Ecto.Query

  def index(conn, _params) do
    fandoms =
      from(f in Erss.Tag.Fandom, order_by: f.name)
      |> Erss.Repo.all()
      |> Enum.map(fn e -> %{name: e.name, url: e.url} end)

    render(conn, "index.html", fandoms: fandoms)
  end
end
