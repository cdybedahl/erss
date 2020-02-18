defmodule ErssWeb.PageController do
  use ErssWeb, :controller

  import Ecto.Query
  alias Erss.Repo

  @pagelen 10

  def index(conn, %{"page" => page}) do
    page = String.to_integer(page)

    q =
      from(f in Erss.Fic,
        join: fr in "fic_user_ratings",
        on: f.id == fr.fic_id and fr.user_id == ^conn.assigns.current_user.id,
        select: {f, fr.total}
      )

    {fics, maxpage} = filter(conn, q, page)

    render(conn, "index.html",
      fics: fics,
      pagelen: @pagelen,
      maxpage: maxpage,
      page: page,
      title: "All Fics",
      route: fn page -> ErssWeb.Router.Helpers.page_path(conn, :index, page) end
    )
  end

  def index(conn, params) do
    index(conn, Map.put(params, "page", "1"))
  end

  def by_tag(conn, %{"page" => page, "id" => id}) do
    page = String.to_integer(page)
    limit = get_session(conn, :show_minimum)
    tag = Repo.get!(Erss.Tag, id)

    q =
      from(
        f in subquery(
          from(t in Erss.Tag,
            join: f in assoc(t, :fics),
            where: t.id == ^id,
            select: f
          )
        ),
        join: fr in "fic_user_ratings",
        on: f.id == fr.fic_id and fr.user_id == ^conn.assigns.current_user.id,
        where: fr.total >= ^limit,
        select: {f, fr.total}
      )

    {fics, maxpage} = filter(conn, q, page)

    render(conn, "index.html",
      fics: fics,
      pagelen: @pagelen,
      maxpage: maxpage,
      page: page,
      title: "Fics tagged '#{tag.name}'",
      route: fn page -> ErssWeb.Router.Helpers.page_path(conn, :by_tag, id, page) end
    )
  end

  def sort_by(conn, %{"sort_by" => type, "show_minimum" => show_minimum, "request_path" => path}) do
    conn =
      case type do
        "order" ->
          put_session(conn, :sort_by, "order")

        _ ->
          put_session(conn, :sort_by, "rating")
      end

    conn =
      case Integer.parse(show_minimum) do
        {n, ""} ->
          put_session(conn, :show_minimum, n)

        _ ->
          conn
      end

    redirect(conn, to: path)
  end

  def to_read(conn, %{"page" => page}) do
    user = conn.assigns.current_user
    page = String.to_integer(page)

    q =
      from(f in Erss.Fic,
        join: fr in "fic_user_ratings",
        on: f.id == fr.fic_id and fr.user_id == ^conn.assigns.current_user.id,
        join: r in assoc(f, :reading_list),
        where: r.user_id == ^user.id,
        select: {f, fr.total}
      )

    {fics, maxpage} = filter(conn, q, page)

    render(conn, "index.html",
      fics: fics,
      pagelen: @pagelen,
      maxpage: maxpage,
      page: page,
      title: "Reading list'",
      route: fn page -> ErssWeb.Router.Helpers.page_path(conn, :to_read, page) end
    )
  end

  def search(conn, _params) do
    render(conn, "search.html")
  end

  ###
  ### Private functions.
  ###

  defp filter(conn, q, page) do
    q =
      case get_session(conn, :sort_by) do
        "rating" ->
          from([f, fr] in q, order_by: [desc: fr.total, desc: f.inserted_at])

        "order" ->
          from(f in q, order_by: [desc: f.id])
      end

    q =
      case get_session(conn, :show_minimum) do
        nil ->
          q

        n when is_integer(n) ->
          from([f, fr] in q, where: fr.total >= ^n)
      end

    maxpage = 1 + div(Repo.aggregate(q, :count) - 1, @pagelen)

    fics =
      from([f, fr] in q,
        limit: @pagelen,
        offset: @pagelen * (^page - 1),
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
        ]
      )
      |> Repo.all()
      |> Enum.map(fn {fic, total} ->
        fic |> Map.put(:total, total) |> Map.put(:rclass, rating_class(total))
      end)

    {fics, maxpage}
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
