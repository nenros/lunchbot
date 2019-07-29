defmodule Lunchbot.Webhook.Lunch do
  @moduledoc false

  def perform(webhook = %Lunchbot.Webhook{}) do
    %{
      user: %{
        session_id: session_id
      }
    } = webhook
    {:ok, lunch} = Lunchbot.Lunchroom.Lunch.get_lunch(session_id, get_iso_day(Map.get(webhook, :params)))
    response = dishes_to_slack_message(lunch)

    {:ok, put_in(webhook.response.body, response)}
  end

  def get_iso_day(:today), do: get_today()
  def get_iso_day(:tomorrow), do: get_tomorrow()
  def get_iso_day(_), do: get_today()

  def dishes_to_slack_message(lunch) do
    %{
      text: "Lunch for day",
      blocks: [format_company(lunch)] ++ format_dishes(lunch.dishes)
    }
  end

  defp format_company(%{company: company, company_image: company_image}), do:
    build_section_block("*#{company}*", company_image, company)

  defp format_dishes(dishes) do
    Enum.map(
      dishes,
      fn
        %{details: details, name: name, image: ""} ->
          build_section_block("*Dish*: #{name}\n *Description*: #{details}")
        %{details: details, name: name, image: image} ->
          build_section_block("Dish: #{name}\n Description: #{details}", image, "dish")
      end
    )
  end

  defp build_section_block(text) do
    %{
      type: "section",
      text: %{
        type: "mrkdwn",
        text: text
      }
    }
  end

  defp build_section_block(text, image, image_text) do
    Map.put(build_section_block(text), :accessory, %{
      type: "image",
      image_url: image,
      alt_text: image_text
    })
  end


  defp get_today(), do: Date.utc_today()
                        |> Date.to_iso8601

  defp get_tomorrow() do
    date = Date.utc_today()
    case Date.day_of_week(date) do
      day when day > 4 ->
        days_to_add = 8 - Date.day_of_week(date)
        Date.add(date, days_to_add)
      _ -> Date.add(date, 1)
    end
    |> Date.to_iso8601()
  end
end
