defmodule ErssWeb.FicController do
  use ErssWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
