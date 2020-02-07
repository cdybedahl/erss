defmodule Erss do
  import Meeseeks.XPath

  @url "https://archiveofourown.org/tags/116/feed.atom"

  def get_feed do
    case HTTPoison.get(@url, [], timeout: 30000, recv_timeout: 20000, follow_redirect: true) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        process_body(body)

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts("Not found :(")

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason)
    end
  end

  def get_and_store_feed do
    get_feed()
    |> Enum.each(&Erss.Fic.get_or_insert/1)
  end

  defp process_body(body) do
    FeederEx.parse!(body)
    |> Map.get(:entries)
    |> Enum.map(fn e ->
      a =
        case e.author do
          "Anonymous" ->
            %{name: "Anonymous", url: "#"}

          _ ->
            aa =
              Meeseeks.parse(e.author)
              |> Meeseeks.one(xpath("//a"))

            %{
              url: Meeseeks.attr(aa, "href"),
              name: Meeseeks.text(aa)
            }
        end

      Map.merge(e, get_metadata(e.summary))
      |> Map.put(:ao3id, e.id)
      |> Map.drop([:__struct__, :summary, :duration, :enclosure, :image, :subtitle, :id])
      |> Map.put(:author, a)
    end)
  end

  defp get_metadata(str) do
    doc = Meeseeks.parse(str)
    [words, chapters, chapter_limit, language] = get_data(doc)

    %{
      characters: get_tags(doc, "Characters"),
      relationships: get_tags(doc, "Relationships"),
      categories: get_tags(doc, "Categories"),
      fandoms: get_tags(doc, "Fandoms"),
      rating: List.first(get_tags(doc, "Rating")),
      warnings: get_tags(doc, "Warnings"),
      additional_tags: get_tags(doc, "Additional Tags"),
      words: words,
      chapters: chapters,
      chapter_limit: chapter_limit,
      language: language,
      raw: str
    }
  end

  defp get_tags(doc, tagtype) do
    Meeseeks.all(doc, xpath("//li[contains(text(),'#{tagtype}')]/a"))
    |> Enum.map(fn tag -> %{url: Meeseeks.attr(tag, "href"), name: Meeseeks.text(tag)} end)
  end

  defp get_data(doc) do
    re = ~r/Words: (\d*), Chapters: (\d+)\/(\d+|\?), Language: (\S+)/

    str =
      Meeseeks.one(doc, xpath("//p[contains(text(), 'Words:')]/text()"))
      |> Meeseeks.html()

    case Regex.run(re, str) do
      [_, words, chapters, "?", language] ->
        [
          to_int(words),
          to_int(chapters),
          nil,
          language
        ]

      [_, words, chapters, chapter_limit, language] ->
        [
          to_int(words),
          to_int(chapters),
          to_int(chapter_limit),
          language
        ]

      nil ->
        [0, 0, 0, str]
    end
  end

  defp to_int(s) do
    case s do
      "" ->
        0

      s ->
        String.to_integer(s)
    end
  end
end
