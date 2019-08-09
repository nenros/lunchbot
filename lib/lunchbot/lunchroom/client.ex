defmodule Lunchbot.Lunchroom.Client do
  use HTTPoison.Base

  @lunchroom_endpoint "https://airhelp.lunchroom.pl"

  def get_session_from_magiclink(magiclink),
      do: get(magiclink)

  def get_lunch_for_date(session_id, date) do
    case get(
           "/select/day/#{date}",
           %{},
           hackney: [
             cookie: session_id
           ]
         ) do
      {:ok, %{body: body}} -> {:ok, body}
    end
  end
end
