defmodule Lunchbot.Webhook do
  require Logger
  use NewRelic.Tracer
  import Lunchbot.Webhook.Errors, only: [error_to_message: 1]

  defstruct [
    :request,
    :action,
    :params,
    :user,
    :error,
    slack_data: %{},
    response: %{
      status: 200,
      body: "",
      blocks: [],
      type: "application/json"
    }
  ]

  alias Lunchbot.Webhook
  alias Lunchbot.Webhook.SlackData
  alias Lunchbot.Webhook.ActionDispatcher
  alias Lunchbot.Webhook.Authorizer

  @trace :run_webhook
  def run_webhook(request) do
    Logger.info("Running webhook")

    with {:ok, webhook} <- build_webhook(request),
         {:ok, webhook} <- slack_data(webhook),
         {:ok, webhook} <- authorize_user(webhook),
         {:ok, webhook} <- dispatch_action(webhook),
         {:ok, webhook} <- run_action(webhook) do
      Logger.info("Action #{webhook.action} run successful, sending async response")
      send_webhook_async(webhook)
    else
      {:error, webhook} ->
        {:ok, send_webhook_async(webhook)}
    end
  end

  def build_webhook(request) do
    {:ok, %Webhook{request: request}}
  end

  def dispatch_action(request), do: ActionDispatcher.dispatch_action(request)

  def authorize_user(request), do: Authorizer.authorize_user(request)

  def slack_data(webhook), do: SlackData.build_slack_data(webhook)

  def send_webhook_async(webhook = %{error: nil}) do
    response_url = Map.get(webhook.slack_data, :response_url)
    blocks = webhook.response.blocks
    Slack.send_by_response_url(response_url, blocks)
  end

  def send_webhook_async(webhook) do
    response_url = Map.get(webhook.slack_data, :response_url)
    Slack.send_by_response_url(response_url, [error_to_message(webhook.error)])
  end

  def run_action(webhook = %Webhook{action: action}) do
    Kernel.apply(action, :perform, [webhook])
  end
end
