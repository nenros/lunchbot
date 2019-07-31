defmodule Lunchbot.Lunchroom.Lunch do
  defstruct [:company, :company_image, dishes: []]
  use HTTPoison.Base

  alias Lunchbot.Lunchroom.Lunch

  @lunchroom_endpoint "https://airhelp.lunchroom.pl"

  def process_request_url(url) do
    @lunchroom_endpoint <> url
  end

  def process_response_body(body) do
    case Lunchbot.Lunchroom.Lunch.HTMLParser.parse(body) do
      {:ok, data} when data != [] ->
        struct(Lunch, %{
          company: Map.get(List.first(data), :company),
          company_image: Map.get(List.first(data), :company_image),
          dishes: map_dishes(data)
        })
      {:ok, _} -> {:error, :no_lunch_choosen}
    end
  end

  def get_lunch(session_id, day) do
    case get(
           "/select/day/#{day}",
           %{},
           hackney: [
             cookie: session_id
           ]
         ) do
      {:ok, %{body: body}} -> {:ok, body}
    end
  end

  defp map_dishes(data), do:
    for dish <- data, into: [], do: struct(Lunchbot.Lunchroom.Lunch.Dish, dish)

  defimpl String.Chars do
    def to_string(%{company: company}), do:
      """
      *Company*: #{company}
      """
  end
end
