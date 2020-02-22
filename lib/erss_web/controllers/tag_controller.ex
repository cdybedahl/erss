defmodule ErssWeb.TagController do
  use ErssWeb, :controller

  @pagelen 25

  import Ecto.Query
  alias Erss.Repo

  def index(conn, %{"type" => type, "page" => page}) do
    q = source(type, conn.assigns.current_user.id)
    page = String.to_integer(page)

    maxpage = 1 + div(Repo.aggregate(q, :count) - 1, @pagelen)

    tags =
      from([f, t] in q,
        order_by: [desc: f.rating, asc: t.name],
        limit: @pagelen,
        offset: @pagelen * (^page - 1)
      )
      |> Repo.all()

    render(conn, "index.html", tags: tags, maxpage: maxpage, type: type, page: page)
  end

  def source(type, user_id) do
    table =
      Map.get(
        %{
          "author" => "author_fic",
          "fandom" => "fandom_fic",
          "additional" => "additional_fic",
          "category" => "category_fic",
          "character" => "character_fic",
          "language" => "language_fic",
          "rating" => "rating_fic",
          "relationship" => "relationship_fic",
          "warning" => "warning_fic"
        },
        type
      )

    q1 =
      from(tt in table,
        join: tur in "tag_user_rating",
        on: tt.tag_id == tur.tag_id and tur.user_id == ^user_id,
        group_by: [tt.tag_id, tur.rating],
        select: %{tag_id: tt.tag_id, rating: tur.rating, count: count(tt.tag_id)}
      )

    from(f in subquery(q1),
      join: t in Erss.Tag,
      on: f.tag_id == t.id,
      select: %{tag: t, rating: f.rating, count: f.count}
    )
  end
end
