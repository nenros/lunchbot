defmodule Lunchbot.Server.Command do
  import Plug.Conn, only: [send_resp: 3]
  def lunch(conn) do
    Task.async(fn ()-> Lunchbot.Webhook.run_webhook(conn) end)
    send_resp(conn, 200, "")
  end

end
