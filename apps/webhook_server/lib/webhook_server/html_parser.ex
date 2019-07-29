defmodule WebhookServer.HTMLParser do

  @moduledoc false

  @text_selectors [
    company: "div.company span.brand",
    name: "div.name",
    details: ["div.details", 1],
  ]

  @images_selectors [
    image: "div.show-more-info img",
    company_image: "span.logo img"
  ]

  def parse_food(html) do
    texts = get_data(html, @text_selectors, :get_text)
    images = get_data(html, @images_selectors, :get_image_src)


    {:ok, Map.merge(texts, images)}
  end

  defp get_data(html, selectors, function),
       do: Enum.reduce(
         selectors,
         %{},
         fn {k, v}, acc ->
           Map.put(acc, k, apply(__MODULE__, function, [html, v]))
         end
       )

  def get_text(html, selector) when is_binary(selector) do
    case Floki.find(html, selector) do
      [{_, _, text}] -> text
      _ -> ""
    end
  end


  def get_text(html, [selector, number]) do
    case Floki.find(html, selector) do
      [{_, _, node}] -> Enum.at(node, number)
      _ -> ""
    end
  end



  def get_image_src(html, selector) do
    case Floki.find(html, selector) do
      [{_, attrs, _}] ->
        {_, v} = Enum.find(attrs, fn {k, v} -> k == "src" end)
        v
      _ -> ""
    end
  end
end
