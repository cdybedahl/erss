defmodule ErssWeb.FicController do
  use ErssWeb, :controller

  @pagelen 25

  import Ecto.Query
  alias Erss.Repo

  def index(conn, %{"page" => page}) do
    p = String.to_integer(page)
    max = Integer.floor_div(Repo.aggregate(Erss.Fic, :count), @pagelen) + 1

    fics =
      from(f in Erss.Fic,
        order_by: [desc: f.id],
        limit: @pagelen,
        preload: [:fandoms, :relationships],
        offset: @pagelen * (^p - 1)
      )
      |> Repo.all()
      |> Enum.map(fn f -> Map.put(f, :total, Erss.Fic.total_rating(f)) end)
      |> Enum.map(&rating_class/1)

    render(conn, "index.html", fics: fics, page: p, max_page: max, len: @pagelen)
  end

  def index(conn, params) do
    index(conn, Map.put(params, "page", "1"))
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
