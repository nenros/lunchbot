defmodule Lunchbot.Lunchroom.Session do
  use HTTPoison.Base


  def get_session_for_user(%{magiclink: magiclink}) do
    case HTTPoison.get magiclink do
      {:ok, %HTTPoison.Response{headers: headers}} ->
        {:ok, read_session_id(headers)}
      _ -> {:error, :cannot_fetch_session}
    end
  end

  defp read_session_id(headers) do
    headers
    |> Enum.filter(
         fn {k, _} -> k == "Set-Cookie" end
       )
    |> Enum.map(
         fn {k, v} ->
           [value | _] = String.split(v, ";")
           "#{value};"
         end
       )
    |> Enum.join(" ")
  end

end
