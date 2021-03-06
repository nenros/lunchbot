defmodule Lunchbot.Server.Command do
  import Plug.Conn, only: [send_resp: 3]

  require Logger

  def lunch(%Plug.Conn{params: params} = conn) do
    Task.start(fn ->
      %{"user_name" => user_name, "text" => text} = params
      Logger.metadata(user_name: user_name, text: text)
      Lunchbot.Command.Lunch.run(params)
    end)

    send_resp(conn, 200, "")
  end
end
