defmodule Lunchbot.Lunchroom.Lunch do
  defstruct [:company, :company_image, dishes: []]
  use HTTPoison.Base



  @lunchroom_endpoint "https://airhelp.lunchroom.pl"

  def process_request_url(url) do
    @lunchroom_endpoint <> url
  end

  def process_response_body(body) do
    with {:ok, data} <- Lunchbot.Lunchroom.Lunch.HTMLParser.parse(body), do:
       %{
        company: Map.get(List.first(data), :company),
        company_image: Map.get(List.first(data), :company_image),
        dishes: Enum.map(
          data,
          fn x -> struct!(
                    Lunchbot.Lunchroom.Lunch.Dish,
                    Map.take(x, [:name, :details, :image])
                  )
          end
        )
      }
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


end
