defmodule Lunchbot.Webhook do
  defstruct [
    :module,
    :params,
    :user,
    slack_data: %{},
    response: %{
      status: 200,
      body: "",
      type: "application/json"
    }
  ]

  @slack_params ["user_id", "user_name", "text"]
  @command_to_module %{
    magiclink: Lunchbot.Webhook.Magiclink,
    today: Lunchbot.Webhook.Lunch,
    tomorrow: Lunchbot.Webhook.Lunch
  }

  alias Lunchbot.Webhook

  @doc """
  Take webhook and request body to extract needed slack data
  """
  def get_slack_data(webhook = %Webhook{}, data) do
    params = data
             |> URI.decode_query
             |> Map.take(@slack_params)
             |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)

    {:ok, Map.put(webhook, :slack_data, params)}
  end

  @doc """
  Take webhook and on slack data set module to perform
  """
  def set_action_to_perform(webhook = %Webhook{slack_data: slack_data}) do
    %{text: text} = slack_data
    [command | params] = String.split(text, " ")

    case get_action_to_perform(command, params) do
      {:ok, action, params} ->
        webhook = webhook
                  |> Map.put(:module, action)
                  |> Map.put(:params, params)
        {:ok, webhook}
      _ -> {:error, :command_unknow}
    end
  end

  defp get_action_to_perform("", _params),
       do: {:ok, Map.get(@command_to_module, :today), ""}

  defp get_action_to_perform(command, params) do
    command = String.to_atom(command)

    cond do
      :magiclink == command -> {:ok, Map.get(@command_to_module, command), params}
      Map.has_key?(@command_to_module, command) -> {:ok, Map.get(@command_to_module, command), command}
      true -> {:error, :command_unknown}
    end
  end

  def set_user_if_exists(webhook = %Webhook{slack_data: slack_data}) do
    case Lunchbot.Repo.Users.find_user_by_user_id(slack_data.user_id) do
      user = %Lunchbot.Repo.Users.User{} -> {:ok, Map.put(webhook, :user, user)}
      _ -> {:ok, webhook}
    end
  end

  def perform_action(webhook = %Webhook{module: module}) do
    {:ok, webhook} = Kernel.apply(module, :perform, [webhook])
    {:ok, webhook}
  end

  def get_possible_actions_with_modules(), do: @command_to_module
end
