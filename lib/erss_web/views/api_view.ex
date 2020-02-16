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

  def render("tags.json", %{tags: tags}) do
    Enum.map(tags, fn tag ->
      %{
        id: tag.id,
        name: tag.name,
        url: tag.url,
        rating: tag.rating
      }
    end)
  end

  def render("set_read.json", %{state: state}) do
    state
  end
end
