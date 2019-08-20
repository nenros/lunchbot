defmodule Lunchbot.Lunchroom.Lunch do
  defstruct [:company, :company_image, dishes: []]

  alias Lunchbot.Lunchroom.Lunch
  alias Lunchbot.Lunchroom.HTMLParser

  def parse_lunch(body) do
    case HTMLParser.parse(body) do
      {:ok, data} when data != [] ->
        [first | _] = data
        [map_company(first) | Enum.map(data, &map_lunch&1)]
      {:ok, []} ->
         [no_lunches]
      {:error, error} ->
        {:error, error}
    end
  end

  def no_lunches, do: """
  No lunches choosen
  """

  def map_company(%{company: company, company_image: nil}),
      do: {company_description(company)}

  def map_company(%{company: company, company_image: image}),
      do: {company_description(company), image, company}

  def map_lunch(%{name: name, details: details, image: nil}),
      do: {dish_description(name, details)}

  def map_lunch(%{name: name, details: details, image: image}),
      do: {dish_description(name, details), image, name}

  defp company_description(company), do: "*Company:* #{company}"
  defp dish_description(name, details), do: """
  *Dish*: #{name}
  *Description*: #{details}
  """
end
