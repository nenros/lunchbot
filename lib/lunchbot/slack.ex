defmodule Slack do
  use HTTPoison.Base
  require Logger

  @hooks_slack_endpoint 'https://hooks.slack.com'

  def process_request_url(url) do
    %{path: path} = URI.parse(url)
    "#{@hooks_slack_endpoint}#{path}"
  end

  def process_request_headers(headers) do
    headers ++ [{"Content-Type", "application/json"}]
  end

  def process_request_body(body) do
    %{
      blocks: Enum.map(body, &build_section_block(&1))
    }
    |> Jason.encode!()
  end

  def send_by_response_url(hook_url, data) do
    case post(hook_url, data) do
      {:ok, %{body: "ok", request: request}} ->
        Logger.info("Response sent correctly")

      {:ok, %{body: error, request: request}} ->
        Logger.error("Slack error: #{error}, Request: #{inspect(request)}")

      {:error, error} ->
        Logger.error("Error: #{error} when response sent")
    end
  end

  defp build_section_block(text) when is_binary(text),
    do: %{
      type: "section",
      text: %{
        type: "mrkdwn",
        text: text
      }
    }

  defp build_section_block({text}), do: build_section_block(text)

  defp build_section_block({text, image, image_text}) do
    Map.put(
      build_section_block(text),
      :accessory,
      %{
        type: "image",
        image_url: image,
        alt_text: image_text
      }
    )
  end
end
