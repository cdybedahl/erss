defmodule ErssWeb.FicController do
  use ErssWeb, :controller

  def index(conn, params) do
    conn
    |> put_view(ErssWeb.FicView)
    |> render(
      "index.html",
      ErssWeb.Helper.paged(Erss.Fic, fn p -> Routes.fic_path(conn, :index, p) end, params)
    )
  end
end
