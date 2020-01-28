defmodule ErssWeb.WarningController do
  use ErssWeb, :controller
  import Ecto.Query

  def index(conn, _params) do
    tags =
      from(f in Erss.Tag.Warning, order_by: f.name)
      |> Erss.Repo.all()

    render(conn, "index.html", tags: tags)
  end
end