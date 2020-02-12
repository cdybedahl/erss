defmodule ErssWeb.ToplistController do
  use ErssWeb, :controller

  import Ecto.Query
  alias Erss.Repo

  @types %{
    "Authors" => :author_fics,
    "Fandoms" => :fandom_fics,
    "Additional tags" => :additional_fics,
    "Categories" => :category_fics,
    "Characters" => :character_fics,
    "Languages" => :language_fics,
    "Ratings" => :rating_fics,
    "Relationships" => :relationship_fics,
    "Warnings" => :warning_fics
  }

  def index(conn, _params) do
    table_data = Enum.map(@types, &get_data/1)
    render(conn, "index.html", table_data: table_data)
  end

  defp get_data({title, assoc}) do
    q =
      from(t in Erss.Tag,
        join: f in assoc(t, ^assoc),
        group_by: t.id,
        select: %{tag: t, count: count(f.id)},
        order_by: [desc: count(f.id)],
        limit: 10
      )

    {title, Repo.all(q)}
  end
end
