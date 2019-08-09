defmodule Lunchbot.Lunchroom.Client do
  use HTTPoison.Base

  @lunchroom_endpoint "https://airhelp.lunchroom.pl"

  def get_session_from_magiclink(magiclink),
    do: get("#{@lunchroom_endpoint}#{magiclink}")

  def get_lunch_for_date(session_id, date),
    do:
      get(
        "#{@lunchroom_endpoint}/select/day/#{date}",
        %{},
        hackney: [
          cookie: session_id
        ]
      )
end
