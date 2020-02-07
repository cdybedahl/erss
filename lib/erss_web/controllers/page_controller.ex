defmodule ErssWeb.PageController do
  use ErssWeb, :controller

  import Ecto.Query
  alias Erss.Repo

  def index(conn, _params) do
    fics =
      from(f in Erss.Fic, preload: [:author, :rating, :categories])
      |> Repo.all()
      |> Enum.map(fn f -> Map.put(f, :total, rating_class(Erss.Fic.total_rating(f))) end)

    render(conn, "index.html", fics: fics)
  end

  defp rating_class(n) do
    cond do
      n > 2 ->
        "good"

      n < 0 ->
        "bad"

      true ->
        "neutral"
    end
  end
end
