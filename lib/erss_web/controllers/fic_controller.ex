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
end
