defmodule Lunchbot.Webhook do
  require Logger
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
      type: "application/json"
    },
  ]


  @errors %{
    magic_link_first: "You have to send magic link from email first"
  }

  alias Lunchbot.Webhook
  alias Lunchbot.Webhook.SlackData
  alias Lunchbot.Webhook.ModuleDispatcher
  alias Lunchbot.Webhook.Authorizer

  def run_webhook(request) do
    with {:ok, webhook} <- build_webhook(request),
         {:ok, webhook} <- slack_data(webhook),
         {:ok, webhook} <- authorize_user(webhook),
         {:ok, webhook} <- dispatch_module(webhook) do
      Logger.info("Running #{webhook.action} for user #{inspect(webhook.user)}")
      Task.async(
        fn () ->
          webhook
          |> run_module
          |> send_webhook_async
        end
      )
      {:ok, :webhook_async}
    else
      {:error, %{error: error}} ->
        Logger.warn("Found error #{error}")
        {:ok, error_to_message(error)}
    end
  end

  def build_webhook(request) do
    {:ok, %Webhook{request: request}}
  end

  def dispatch_module(request), do: ModuleDispatcher.dispatch_module(request)

  def authorize_user(request), do: Authorizer.authorize_user(request)

  def slack_data(webhook), do: SlackData.build_slack_data(webhook)

  def send_webhook_async(webhook = %{error: nil}) do
    response_url = get_in(webhook, [:slack_data, :response_url])
    text = get_in(webhook, [:response, :body])
    Slack.send_by_response_url(response_url, text)
  end

  def send_webhook_async(webhook) do
    response_url = get_in(webhook, [:slack_data, :response_url])
    text = error_to_message(webhook.error)
    Slack.send_by_response_url(response_url, text)
  end

  def run_module(webhook = %Webhook{action: action}) do
    Kernel.apply(action, :perform, [webhook])
  end

  def error_to_message(error) do
    case Map.has_key?(@errors, error) do
      true -> Map.get(@errors, error)
      _ -> "Unknown error, please contact creator"
    end
  end
end
