defmodule Lunchbot.Command.Lunch do
  @moduledoc false
  require Logger

  alias Lunchbot.Command.Lunch.Magiclink

  def run(params) do
    Logger.debug("Running params: #{inspect(params)}")
    case action(params) do
      {:ok, response} ->
        Logger.info("Command run successful")
        {:ok, response}
      {:error, error} ->
        Logger.error("Found error: #{error}")
        {:error, error}
    end
  end

  defp action(%{"text" => ""} = params), do: send_today_lunch(params)
  defp action(%{"text" => <<"today", _ :: binary>>} = params), do: send_today_lunch(params)
  defp action(%{"text" => <<"tomorrow", _ :: binary>>} = params), do: send_tomorrow_lunch(params)
  defp action(%{"text" => <<"magiclink", _ :: binary>>} = params), do: update_magiclink(params)
  defp action(params), do: send_help(params)

  def send_help(params) do
    Logger.metadata(action: :help_message)
    Logger.debug("Running help message")
    with {:ok, message} <- Lunchbot.Command.Lunch.Help.get_message(),
         %{"response_url" => response_url} <- params, do:
           Lunchbot.Slack.send_by_response_url(response_url, message)
  end

  def send_today_lunch(params), do: nil
  def send_tomorrow_lunch(params), do: nil
  def update_magiclink(params) do
    Logger.metadata(action: :magiclink)
    Logger.debug("Running magiclink action")
    with {:ok, message} <- Magiclink.perform(params),
         %{"response_url" => response_url} <- params, do:
           Lunchbot.Slack.send_by_response_url(response_url, message)
  end

end
