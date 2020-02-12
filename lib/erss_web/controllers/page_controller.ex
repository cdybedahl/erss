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
        ]
      )

    q =
      case get_session(conn, :sort_by) do
        "order" ->
          from(f in q, order_by: [desc: f.id])

        _ ->
          from([f, fr] in q, order_by: [desc: fr.total, desc: f.inserted_at])
      end

    q =
      case get_session(conn, :hide_negative) do
        "true" ->
          from([f, fr] in q, where: fr.total > 0)

        _ ->
          q
      end

    maxpage = div(Repo.aggregate(q, :count), @pagelen)

    fics =
      from([f, fr] in q,
        limit: @pagelen,
        offset: @pagelen * (^page - 1)
      )
      |> Repo.all()
      |> Enum.map(fn {fic, total} ->
        fic |> Map.put(:total, total) |> Map.put(:rclass, rating_class(total))
      end)

    render(conn, "index.html",
      fics: fics,
      pagelen: @pagelen,
      maxpage: maxpage,
      page: page,
      title: "All Fics"
    )
  end

  def index(conn, params) do
    index(conn, Map.put(params, "page", "1"))
  end

  def by_tag(conn, %{"page" => page, "id" => id}) do
    page = String.to_integer(page)
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
        ]
      )

    q =
      case get_session(conn, :sort_by) do
        "rating" ->
          from([f, fr] in q, order_by: [desc: fr.total, desc: f.inserted_at])

        "order" ->
          from(f in q, order_by: [desc: f.id])
      end

    q =
      case get_session(conn, :hide_negative) do
        "true" ->
          from([f, fr] in q, where: fr.total > 0)

        "false" ->
          q
      end

    maxpage = div(Repo.aggregate(q, :count), @pagelen)

    fics =
      from([f, fr] in q,
        limit: @pagelen,
        offset: @pagelen * (^page - 1)
      )
      |> Repo.all()
      |> Enum.map(fn {fic, total} ->
        fic |> Map.put(:total, total) |> Map.put(:rclass, rating_class(total))
      end)

    render(conn, "index.html",
      fics: fics,
      pagelen: @pagelen,
      maxpage: maxpage,
      page: page,
      title: "Fics tagged '#{tag.name}'"
    )
  end

  def sort_by(conn, %{"sort_by" => type, "hide_negative" => hide}) do
    conn =
      case type do
        "order" ->
          put_session(conn, :sort_by, "order")

        _ ->
          put_session(conn, :sort_by, "rating")
      end

    conn =
      case hide do
        "true" ->
          put_session(conn, :hide_negative, "true")

        "false" ->
          put_session(conn, :hide_negative, "false")
      end

    redirect(conn, to: "/")
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
