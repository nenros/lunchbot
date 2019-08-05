defmodule Lunchbot.Server.Router do
  use Plug.Router
  use ScoutApm.Instrumentation

  if Mix.env() == :dev do
    use Plug.Debugger, otp_app: :lunchbot
  end

  plug(Plug.Logger)
  plug(Plug.Parsers, parsers: [:urlencoded, :multipart])
  plug(Plug.Head)
  plug(Lunchbot.Server.Middleware.SlackParams)
  plug(:match)
  plug(:dispatch)

  alias Lunchbot.Server.Command

  get("/", do: send_resp(conn, 200, ""))

  post("webhook", do: Command.lunch(conn))
end
