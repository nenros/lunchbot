defmodule Lunchbot.Webhook.ActionDispatcher do
  @command_to_module %{
    magiclink: Lunchbot.WebhookAction.Magiclink,
    today: Lunchbot.WebhookAction.Lunch,
    tomorrow: Lunchbot.WebhookAction.Lunch,
    help: Lunchbot.WebhookAction.Help
  }

  @doc """
  Take webhook and on slack data set module to perform
  """
  def dispatch_action(webhook) do
    [command | params] = String.split(webhook.slack_data.text, " ")

    case get_action_to_perform(command, params) do
      {:ok, action, params} ->
        {:ok, %{webhook | action: action, params: params}}

      _ ->
        {:error, %{webhook | error: :command_unknow}}
    end
  end

  defp get_action_to_perform("", _params),
    do: {:ok, Map.get(@command_to_module, :today), ""}

  defp get_action_to_perform(command, params) do
    command = String.to_atom(command)

    cond do
      :magiclink == command ->
        {:ok, Map.get(@command_to_module, command), params}

      Map.has_key?(@command_to_module, command) ->
        {:ok, Map.get(@command_to_module, command), command}

      true ->
        {:ok, Lunchbot.WebhookAction.Help, []}
    end
  end

  def get_possible_actions_with_modules(), do: @command_to_module
end
