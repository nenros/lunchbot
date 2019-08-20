defmodule Lunchbot.Lunchroom do
  @lunchroom_client Application.get_env(:lunchbot, :lunchroom_client)

  @callback get_session_from_magiclink(String) :: {:ok, String}
  @callback get_lunch_for_date(String, String) :: {:ok, list, String}

  def get_session_from_magiclink(magiclink) do
    with %{path: path} <- URI.parse(magiclink),
         {:ok, %{status_code: 302, headers: headers}} <-
           @lunchroom_client.get_session_from_magiclink(path),
         {:ok, session_data} <- read_session_id(headers),
         do: {:ok, session_data}
  end

  def get_lunch_for_date(session, date) do
    case @lunchroom_client.get_lunch_for_date(session, date) do
      {:ok, %{body: "User not logged in"}} -> {:error, :need_revalidate}
      {:ok, %{body: body}} ->
        {:ok, parse_lunch(body)}
      {:error, error} -> {:error, error}
    end
  end

  def read_session_id(headers), do:
    Lunchbot.Lunchroom.Session.read_session_id(headers)

  def parse_lunch(body), do:
    Lunchbot.Lunchroom.Lunch.parse_lunch(body)
end
