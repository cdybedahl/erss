defmodule ErssWeb.PageController do
  use ErssWeb, :controller

  import Ecto.Query
  alias Erss.Repo

  @pagelen 10

  def index(conn, %{"page" => page}) do
    page = String.to_integer(page)

    q =
      from(f in Erss.Fic,
        join: fr in "fic_ratings",
        on: f.id == fr.fic_id,
        select: {f, fr.total},
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
        order_by: [desc: fr.total, desc: f.inserted_at]
      )

    maxpage = div(Repo.aggregate(q, :count), @pagelen)

    fics =
      from(q,
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
