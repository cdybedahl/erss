defmodule ErssWeb.Helper do
  import Ecto.Query
  alias Erss.Repo

  @pagelen 25

  def paged(source, route, params = %{"page" => page}) when is_binary(page) do
    paged(source, route, %{params | "page" => String.to_integer(page)})
  end

  def paged(source, route, %{"page" => page}) when is_integer(page) do
    total = Repo.aggregate(source, :count)
    max = Integer.floor_div(total, @pagelen) + 1

    fics =
      from(f in source,
        order_by: [desc: f.id],
        limit: @pagelen,
        offset: @pagelen * (^page - 1)
      )
      |> Repo.all()
      |> Repo.preload([:fandoms, :relationships, :warnings, :categories, :additional_tags])
      |> Enum.map(fn f -> Map.put(f, :total, Erss.Fic.total_rating(f)) end)
      |> Enum.sort(fn a, b -> a.total > b.total end)
      |> Enum.map(&Erss.Fic.rating_class/1)

    %{fics: fics, page: page, max_page: max, len: @pagelen, pagination: route, total: total}
  end

  def paged(source, route, params) do
    paged(source, route, Map.put(params, "page", 1))
  end
end
