defmodule Lunchbot.Lunchroom.HTMLParser do
  @image_prefix "https://airhelp.lunchroom.pl"

  @text_selectors [
    company: "div.company span.brand",
    name: "div.name",
    details: "div.details"
  ]

  @images_selectors [
    image: ".img.opacity img",
    company_image: "span.logo img"
  ]

  def parse(html) do
    {
      :ok,
      html
      |> Floki.find(".one-day div.one-day-box")
      |> Enum.map(fn box -> get_dish(box) end)
    }
  end

  defp get_dish(html) do
    texts = get_data(html, @text_selectors, :get_text)
    images = get_data(html, @images_selectors, :get_image_src)

    Map.merge(texts, images)
  end

  defp get_data(html, selectors, function),
       do:
         Enum.reduce(
           selectors,
           %{},
           fn {k, v}, acc ->
             Map.put(acc, k, apply(__MODULE__, function, [html, v]))
           end
         )

  def get_text(html, selector) when is_binary(selector) do
    case Floki.find(html, selector) do
      html ->
        Floki.text(html)
        |> String.replace("Ingredients:", "")
        |> String.trim()
      _ ->
        ""
    end
  end

  def get_image_src(html, selector) do
    case Floki.find(html, selector) do
      [{_, attrs, _}] ->
        {_, v} = Enum.find(attrs, fn {k, _} -> k == "src" end)
        "#{@image_prefix}#{v}"

      _ ->
        nil
    end
  end
end
