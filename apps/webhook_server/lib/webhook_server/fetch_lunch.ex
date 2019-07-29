defmodule WebhookServer.FetchLunch do
  require IEx
  @lunchroom_endpoint "airhelp.lunchroom.pl"

  def perform(day, %WebhookServer.Request{user_id: user_id}) do
    case Users.find_user_by_user_id(user_id) do
      %Users.User{} = user -> fetch_user_lunch(day, user)
      nil -> {:error, "Please send yours magic link at the beginning using `/lunch magic_link <magic_link>`"}
    end
  end

  defp fetch_user_lunch(day, user) do
    if user.session_id == nil do
      {:ok, user} = user
                    |> fetch_session_id
                    |> Users.save_session_id(user)
    end
    iso_date = date_to_iso()
    %{session_id: session_id} = user

    fetch_lunch(iso_date, session_id)
  end

  defp fetch_lunch(iso_date, session_id) do
    {:ok, conn} = Mint.HTTP.connect(:https, @lunchroom_endpoint, 443)
    {:ok, conn, request_ref} = Mint.HTTP.request(
      conn,
      "GET",
      "/select/day/#{iso_date}",
      [{"cookie", session_id}],
      ""
    )
    receive do message ->
      case Mint.HTTP.stream(conn, message) do
        {:ok, conn, responses} -> read_lunch_from_response(responses)
        {:error, _} -> {:error, "Could you send yours magic link once again?"}
      end
    end

  end

  defp fetch_session_id(%Users.User{magic_link: magic_link}) do
    link = URI.parse(magic_link)
    {:ok, conn} = Mint.HTTP.connect(:https, link.host, 443)
    {:ok, conn, request_ref} = Mint.HTTP.request(conn, "GET", link.path, [], "")
    receive do message ->
      case Mint.HTTP.stream(conn, message) do
        {:ok, conn, responses} -> read_session_id(responses)
        {:error, _} -> {:error, "Could you send yours magic link once again?"}
      end
    end
  end

  defp read_lunch_from_response(responses) do
    {_, _, data} = Enum.find(responses, fn {type, _, _} -> type == :data end)
    response = data
               |> WebhookServer.HTMLParser.parse_food
               |> parse_to_response
    {:ok, response}
  end

  defp parse_to_response({:ok, data}) do
  {:ok, %{
      text: "Your lunch: #{Map.get(data, :name)}",
      attachaments: [
        %{text: "Ingredients: #{Map.get(data, :details)}"},
        %{
          text: "from: #{Map.get(data, :company)}"
        }]
    }}
  end



  defp read_session_id(responses) do
    {_, _, headers} = Enum.find(responses, fn {type, _, _} -> type == :headers end)
    headers
    |> Enum.filter(
         fn {k, _} -> k == "set-cookie" end
       )
    |> Enum.map(
         fn {k, v} ->
           [value | _] = String.split(v, ";")
           "#{value};"
         end
       )
    |> Enum.join(" ")
  end

  defp date_to_iso(),
       do: Date.to_iso8601(~D[2019-07-22])

end
