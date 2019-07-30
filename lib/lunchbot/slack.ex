defmodule Slack do
  use HTTPoison.Base

  @hooks_slack_endpoint 'https://hooks.slack.com'

  def send_by_response_url(hook_url, data) do
    case post(hook_url, data) do
      {:ok, _response} -> Logger.info("Response sent correctly")
      {:error, error} -> Logger.error("Error: #{error} when response sent")
    end
  end

end
