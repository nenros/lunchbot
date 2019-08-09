defmodule Lunchbot.Slack do
  require Logger

  @slack_client Application.get_env(:lunchbot, :slack_client)

  @callback send_by_response_url(String, List) :: {:ok, Map}

  def send_by_response_url(hook_url, data) do
    case @slack_client.send_by_response_url(hook_url, data) do
      {:ok, %{body: "ok"}} ->
        Logger.info("Response sent correctly")
        {:ok, :ok}

      {:ok, %{body: error, request: request}} ->
        Logger.error("Slack error: #{error}, Request: #{inspect(request)}")
        {:error, :request}

      {:error, error} ->
        Logger.error("Error: #{error} when response sent")
        {:error, :something_else}
    end
  end
end
