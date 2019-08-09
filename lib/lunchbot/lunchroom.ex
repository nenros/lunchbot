defmodule Lunchbot.Lunchroom do
  @lunchroom_client Application.get_env(:lunchbot, :lunchroom_client)

  @callback get_session_from_magiclink(String) :: {:ok, String}

  def get_session_from_magiclink(magiclink) do
    with   %{path: path} <- URI.parse(magiclink),
           {:ok, %{status_code: 302, headers: headers}} <- @lunchroom_client.get_session_from_magiclink(path),
           {:ok, session_data} <- read_session_id(headers),
           {:ok, session_data} <- check_required_data(session_data), do:
             {:ok, session_data}
  end

  def get_lunch_for_date(session, day), do: nil

  def read_session_id(headers) do
    Enum.reduce(
      headers,
      "",
      fn {k, v}, acc ->
        case k == "Set-Cookie" do
          true ->
            [value | _] = String.split(v, ";")
            "#{acc}#{value}; "
          _ -> acc
        end
      end
    )
  end

  def check_required_data(session) do
    with true <- String.contains?(session, "PHPSESSID"),
         true <- String.contains?(session, "O2L"),
         true <- String.contains?(session, "O2P"), do:
           {:ok, session}
  end
end
