defmodule Lunchbot.Server.Command do
  import Plug.Conn, only: [send_resp: 3]

  def lunch(conn) do
    Task.start(Lunchbot.Webhook, :run_webhook, [conn])
    send_resp(conn, 200, "")
  end
end
