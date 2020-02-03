defmodule ErssWeb.Helper do
  import Ecto.Query
  alias Erss.Repo

  @pagelen 25

  def paged(source, route, params = %{"page" => page}) when is_binary(page) do
    paged(source, route, %{params | "page" => String.to_integer(page)})
  end

  def paged(source, route, %{"page" => page}) when is_integer(page) do
    max = Integer.floor_div(Repo.aggregate(source, :count), @pagelen) + 1

    fics =
      from(f in source,
        order_by: [desc: f.id],
        limit: @pagelen,
        preload: [:fandoms, :relationships],
        offset: @pagelen * (^page - 1)
      )
      |> Repo.all()
      |> Enum.map(fn f -> Map.put(f, :total, Erss.Fic.total_rating(f)) end)
      |> Enum.map(&Erss.Fic.rating_class/1)

    %{fics: fics, page: page, max_page: max, len: @pagelen, pagination: route}
  end
end
