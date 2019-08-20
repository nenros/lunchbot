defmodule Lunchbot.Command.Lunch do
  @moduledoc false
  require Logger

  import ScoutApm.Tracing

  @callback run(map) :: {:ok, list} :: {:error, :error}

  def run(%{"text" => ""} = params), do: run_command(Lunchbot.Command.Lunch.Lunch, params, :lunch)

  def run(%{"text" => <<"today", _::binary>>} = params),
    do: run_command(Lunchbot.Command.Lunch.Lunch, params, :lunch)

  def run(%{"text" => <<"tomorrow", _::binary>>} = params),
    do: run_command(Lunchbot.Command.Lunch.Lunch, params, :lunch)

  def run(%{"text" => <<"magiclink", _::binary>>} = params),
    do: run_command(Lunchbot.Command.Lunch.Magiclink, params, :magiclink)

  def run(params), do: run_command(Lunchbot.Command.Lunch.Help, params, :help)

  def run_command(command, params, action_name) do
    transaction(:background, "Lunch.#{action_name}") do
      Logger.metadata(action: action_name)
      Logger.info("Running #{action_name} action")
      Logger.debug("Running params: #{inspect(params)}")

      with {:ok, message} <- apply(command, :run, [params]),
           %{"response_url" => response_url} <- params do
        Logger.debug("Message to send: #{inspect(message)}")
        Lunchbot.Slack.send_by_response_url(response_url, message)
      else
        {:error, error} ->
          Logger.error("Command returned error: #{error}")
          {:error, error}
      end
    end
  end
end
