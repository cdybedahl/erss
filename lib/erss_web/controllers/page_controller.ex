defmodule ErssWeb.PageController do
  use ErssWeb, :controller
  alias Erss.Repo
  import Ecto.Query

  def index(conn, _params) do
    fic =
      from(f in Erss.Fic, order_by: [desc: :id], limit: 1)
      |> Repo.one()

    warnings = count_tags(:warnings)
    categories = count_tags(:categories)
    ratings = count_tags(:rating)
    fandoms = count_tags(:fandoms)
    characters = count_tags(:characters)
    relationships = count_tags(:relationships)
    authors = count_tags(:author)
    additional = count_tags(:additional_tags)

    render(conn, "index.html",
      fic: fic,
      rating: Erss.Fic.total_rating(fic),
      warnings: warnings,
      categories: categories,
      ratings: ratings,
      fandoms: fandoms,
      characters: characters,
      relationships: relationships,
      authors: authors,
      additional: additional
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
