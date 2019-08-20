defmodule Lunchbot.Lunchroom.Session do
  def read_session_id(headers) do
    headers
    |> Enum.reduce(
      "",
      &session_header_reducer(&1, &2)
    )
    |> check_required_data
  end

  def check_required_data(session) do
    with true <- String.contains?(session, "O2L"),
         true <- String.contains?(session, "O2P") do
      {:ok, session}
    else
      _ -> {:error, :session_not_correct}
    end
  end

  def session_header_reducer({k = "Set-Cookie", v}, acc) do
    [value | _] = String.split(v, ";")
    "#{acc}#{value}; "
  end

  def session_header_reducer(_, acc), do: acc
end
