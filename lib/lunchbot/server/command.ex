defmodule Lunchbot.Server.Command do
  import Plug.Conn, only: [send_resp: 3]
  require ScoutApm.Tracing

  def lunch(conn) do
    Task.start(
      fn ->
        ScoutApm.Tracing.transaction(:background, "Webhook") do
          Lunchbot.Webhook.run_webhook(conn)
        end
      end
    )
    send_resp(conn, 200, "")
  end
end
