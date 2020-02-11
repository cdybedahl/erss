defmodule ErssWeb.TagController do
  use ErssWeb, :controller

  @pagelen 25

  import Ecto.Query
  alias Erss.Repo

  def index(conn, %{"type" => type, "page" => page}) do
    q = type_to_source(type)
    page = String.to_integer(page)
    maxpage = div(Repo.aggregate(from(f in q, select: f, distinct: true), :count), @pagelen)

    tags =
      from(t in q,
        select: {t, count(t.id)},
        group_by: t.id,
        order_by: [desc: t.rating, asc: t.name],
        limit: @pagelen,
        offset: @pagelen * (^page - 1)
      )
      |> Repo.all()

    render(conn, "index.html", tags: tags, maxpage: maxpage, type: type, page: page)
  end

  defp type_to_source(type) do
    assoc =
      Map.get(
        %{
          "author" => :author_fics,
          "fandom" => :fandom_fics,
          "additional" => :additional_fics,
          "category" => :category_fics,
          "character" => :character_fics,
          "language" => :language_fics,
          "rating" => :rating_fics,
          "relationship" => :relationship_fics,
          "warning" => :warning_fics
        },
        type
      )

    from(t in Erss.Tag,
      join: j in assoc(t, ^assoc)
    )
  end
end
