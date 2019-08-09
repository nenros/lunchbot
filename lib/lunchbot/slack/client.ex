defmodule Lunchbot.Slack.Client do
  use HTTPoison.Base
  @behaviour Lunchbot.Slack

  @hooks_slack_endpoint 'https://hooks.slack.com'

  @impl Lunchbot.Slack
  def send_by_response_url(hook_url, data), do: post(hook_url, data)

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
