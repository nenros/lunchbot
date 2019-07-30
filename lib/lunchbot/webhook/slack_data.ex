defmodule Lunchbot.Webhook.SlackData do
  @slack_params ["user_id", "user_name", "text", "response_url", "token"]

  @doc """
  Take webhook and request body to extract needed slack data
  """
  def build_slack_data(webhook) do
    params = webhook.request.body
             |> URI.decode_query
             |> Map.take(@slack_params)
             |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)

    {:ok, %{webhook | slack_data: params}}
  end
end
