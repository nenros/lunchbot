defmodule Lunchbot.Server.Middleware.SlackParams do
  def init(options), do: options

  def call(%Plug.Conn{params: %{"user_name" => user_name, "text" => text}} = conn, opts) do
    Logger.metadata([user_name: user_name, text: text])
    conn
  end

  def call(conn) do
    Logger.metadata(user_name: :no_slack_data)
    conn
  end
end
