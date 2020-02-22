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

  def source("fandom", user), do: table_source("fandom_fic", user)
  def source("additional", user), do: table_source("additional_fic", user)
  def source("character", user), do: table_source("character_fic", user)
  def source("category", user), do: table_source("category_fic", user)
  def source("relationship", user), do: table_source("relationship_fic", user)
  def source("warning", user), do: table_source("warning_fic", user)

  def source("author", user), do: fic_source("author_id", user)
  def source("rating", user), do: fic_source("rating_id", user)
  def source("language", user), do: fic_source("language_id", user)

  def table_source(table, user_id) do
    q1 =
      from(tt in table,
        join: tur in "tag_user_rating",
        on: tt.tag_id == tur.tag_id and tur.user_id == ^user_id,
        group_by: [tt.tag_id, tur.rating],
        select: %{tag_id: tt.tag_id, rating: tur.rating, count: count(tt.tag_id)}
      )

    common_source(q1)
  end

  # The next three repeat a lot of code. It must be possible to fix.
  def fic_source("rating_id", user_id) do
    q1 =
      from(tur in "tag_user_rating",
        join: f in Erss.Fic,
        on: tur.tag_id == f.rating_id,
        where: tur.user_id == ^user_id,
        group_by: [tur.tag_id, tur.rating],
        select: %{tag_id: tur.tag_id, rating: tur.rating, count: count([tur.tag_id, tur.rating])}
      )

    common_source(q1)
  end

  def fic_source("author_id", user_id) do
    q1 =
      from(tur in "tag_user_rating",
        join: f in Erss.Fic,
        on: tur.tag_id == f.author_id,
        where: tur.user_id == ^user_id,
        group_by: [tur.tag_id, tur.rating],
        select: %{tag_id: tur.tag_id, rating: tur.rating, count: count([tur.tag_id, tur.rating])}
      )

    common_source(q1)
  end

  def fic_source("language_id", user_id) do
    q1 =
      from(tur in "tag_user_rating",
        join: f in Erss.Fic,
        on: tur.tag_id == f.language_id,
        where: tur.user_id == ^user_id,
        group_by: [tur.tag_id, tur.rating],
        select: %{tag_id: tur.tag_id, rating: tur.rating, count: count([tur.tag_id, tur.rating])}
      )

    common_source(q1)
  end

  def common_source(q1) do
    from(f in subquery(q1),
      join: t in Erss.Tag,
      on: f.tag_id == t.id,
      select: %{tag: t, rating: f.rating, count: f.count}
    )
  end
end
