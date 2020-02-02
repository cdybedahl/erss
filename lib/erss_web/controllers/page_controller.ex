defmodule ErssWeb.PageController do
  use ErssWeb, :controller
  alias Erss.Repo
  import Ecto.Query

  def index(conn, _params) do
    fic =
      from(f in Erss.Fic, order_by: [desc: :id], limit: 1)
      |> Repo.one()

    render(conn, "index.html", fic: fic, rating: Erss.Fic.total_rating(fic))
  end
end
