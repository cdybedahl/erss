defmodule ErssWeb.TagController do
  use ErssWeb, :controller

  @pagelen 25

  import Ecto.Query
  alias Erss.Repo

  def index(conn, %{"type" => type, "page" => page}) do
    q = type_to_source(type)
    page = String.to_integer(page)
    maxpage = div(Repo.aggregate(q, :count), @pagelen)

    tags =
      from(q,
        limit: @pagelen,
        offset: @pagelen * (^page - 1)
      )
      |> Repo.all()

    render(conn, "index.html", tags: tags, maxpage: maxpage, type: type, page: page)
  end

  defp type_to_source(type) do
    table =
      Map.get(
        %{
          "fandom" => "fandom_fic",
          "additional" => "additional_fic",
          "category" => "category_fic",
          "character" => "character_fic",
          "relationship" => "relationship_fic",
          "warning" => "warning_fic"
        },
        type
      )

    from(t in Erss.Tag,
      join: j in ^table,
      on: t.id == j.tag_id,
      select: t,
      distinct: true,
      order_by: [desc: t.rating, asc: t.name]
    )
  end
end
