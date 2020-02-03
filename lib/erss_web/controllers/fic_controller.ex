defmodule ErssWeb.FicController do
  use ErssWeb, :controller

  def index(conn, params) do
    render(conn, ErssWeb.FicView, "index.html", ErssWeb.Helper.paged(Erss.Fic, &Routes.fic_path/3, params))
  end
end
