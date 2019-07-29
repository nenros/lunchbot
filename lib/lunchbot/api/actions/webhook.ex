defmodule Lunchbot.API.Actions.Webhook do
  use Raxx.SimpleServer
  alias Lunchbot.API

  @impl Raxx.SimpleServer
  def handle_request(request = %{method: :POST}, _state) do
    webhook = %Lunchbot.Webhook{}
    with {:ok, webhook} <- Lunchbot.Webhook.get_slack_data(webhook, request.body),
         {:ok, webhook} <- Lunchbot.Webhook.set_action_to_perform(webhook),
         {:ok, webhook} <- Lunchbot.Webhook.set_user_if_exists(webhook),
         {:ok, webhook = %{response: respone}} <- Lunchbot.Webhook.perform_action(webhook),
    do:
    response(:ok)
    |> API.set_json_payload(respone.body)
  end
end
