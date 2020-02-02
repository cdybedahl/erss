defmodule ErssWeb.FicController do
  use ErssWeb, :controller

  import Ecto.Query
  alias Erss.Repo

  def index(conn, %{"page" => page}) do
    p = String.to_integer(page)

    fics =
      from(f in Erss.Fic,
        order_by: [desc: f.id],
        limit: 25,
        preload: :fandoms,
        offset: 25 * ^p
      )
      |> Repo.all()
      |> Enum.map(fn f -> Map.put(f, :total, Erss.Fic.total_rating(f)) end)
      |> Enum.map(&rating_class/1)

    warnings = count_tags(:warnings)
    categories = count_tags(:categories)
    ratings = count_tags(:rating)
    fandoms = count_tags(:fandoms)

    render(conn, "index.html",
      fics: fics,
      warnings: warnings,
      categories: categories,
      ratings: ratings,
      fandoms: fandoms
    )
  end

  def index(conn, params) do
    index(conn, Map.put(params, "page", "0"))
  end

  defp count_tags(tag) do
    from(f in Erss.Fic,
      join: ff in assoc(f, ^tag),
      select: {[ff.name, ff.url], count(ff.id)},
      group_by: [ff.name, ff.url]
    )
    |> Repo.all()
    |> Enum.sort(fn {_, m}, {_, n} -> m >= n end)
    |> Enum.take(10)
  end

  defp rating_class(fic = %{:total => total}) when total < 0 do
    Map.put(fic, :class, "bad")
  end

  defp rating_class(fic = %{:total => total}) when total > 4 do
    Map.put(fic, :class, "good")
  end

  defp rating_class(fic) do
    Map.put(fic, :class, "neutral")
  end
end
