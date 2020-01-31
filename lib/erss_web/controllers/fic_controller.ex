defmodule ErssWeb.FicController do
  use ErssWeb, :controller

  import Ecto.Query
  alias Erss.Repo

  def index(conn, _params) do
    fics =
      from(f in Erss.Fic,
        order_by: [desc: f.id],
        limit: 25,
        preload: :fandoms
      )
      |> Repo.all()

    render(conn, "index.html", fics: fics)
  end
end
