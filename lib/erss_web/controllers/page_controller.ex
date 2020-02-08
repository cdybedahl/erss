defmodule ErssWeb.PageController do
  use ErssWeb, :controller

  import Ecto.Query
  alias Erss.Repo

  @pagelen 10

  def index(conn, %{"page" => page}) do
    q =
      from(f in Erss.Fic,
        join: fr in "fic_ratings",
        on: f.id == fr.fic_id,
        where: fr.total > 0
      )

    page = String.to_integer(page)
    maxpage = div(Repo.aggregate(q, :count), @pagelen)

    fics =
      from(f in Erss.Fic,
        join: fr in "fic_ratings",
        on: f.id == fr.fic_id,
        select: {f, fr.total},
        where: fr.total > 0,
        preload: [
          :author,
          :rating,
          :categories,
          :fandoms,
          :additional_tags,
          :warnings,
          :characters,
          :relationships,
          :language
        ],
        order_by: [desc: fr.total, desc: f.inserted_at],
        limit: @pagelen,
        offset: @pagelen * (^page - 1)
      )
      |> Repo.all()
      |> Enum.map(fn {fic, total} ->
        fic |> Map.put(:total, total) |> Map.put(:rclass, rating_class(total))
      end)

    render(conn, "index.html", fics: fics, pagelen: @pagelen, maxpage: maxpage, page: page)
  end

  def index(conn, params) do
    index(conn, Map.put(params, "page", "1"))
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
