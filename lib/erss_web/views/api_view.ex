defmodule ErssWeb.ApiView do
  use ErssWeb, :view

  def render("tag.json", %{tag: tag}) do
    %{
      id: tag.id,
      name: tag.name,
      url: tag.url,
      rating: tag.rating
    }
  end
end
