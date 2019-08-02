defmodule Lunchbot.Server.Router do
  use Plug.Router

  if Mix.env == :prod do
    use NewRelic.Transaction
  end

  if Mix.env == :dev do
    use Plug.Debugger, otp_app: :lunchbot
  end


  plug Plug.Logger
  plug Plug.Parsers, parsers: [:urlencoded, :multipart]
  plug :match
  plug :dispatch

  alias Lunchbot.Server.Command


  post "webhook", do: Command.lunch(conn)

end
