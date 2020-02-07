defmodule ErssWeb.PageController do
  use ErssWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", fics: Erss.Fic.all())
  end
end
