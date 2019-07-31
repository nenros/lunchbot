defmodule Lunchbot.WebhookAction.Lunch do
  @moduledoc false

  def perform(%Lunchbot.Webhook{user: nil} = webhook),
      do: {:error, %{webhook | error: :magic_link_first}}

  def perform(webhook = %Lunchbot.Webhook{}) do
    session_id = webhook.user.session_id

    with {:ok, date} <- get_iso_day(Map.get(webhook, :params)),
         {:ok, lunch} <- Lunchbot.Lunchroom.Lunch.get_lunch(session_id, date) do
      {:ok, put_in(webhook.response.blocks, lunch_to_slack_message(lunch, date))}
    else
      {:error, :no_lunch_choosen} -> {:ok, put_in(webhook.response.blocks, no_lunch_choosen())}
    end
  end

  def get_iso_day(:today), do: get_today()
  def get_iso_day(:tomorrow), do: get_tomorrow()
  def get_iso_day(_), do: get_today()

  def lunch_to_slack_message(lunch, date), do:
     [{"*Lunch for day*: #{date}"}, format_company(lunch)] ++ format_dishes(lunch.dishes)

  defp format_company(%{company: company, company_image: company_image} = lunch), do:
    {to_string(lunch), company_image, company}

  defp format_dishes(dishes) do
    Enum.map(
      dishes,
      fn
        %{image: nil} = dish ->
          to_string(dish)
        %{image: image} = dish ->
          {to_string(dish), image, dish.name}
      end
    )
  end

  defp get_today(), do: {:ok, Date.utc_today()
                        |> Date.to_iso8601}

  defp get_tomorrow() do
    today = Date.utc_today()
    next_day = case Date.day_of_week(today) do
      day when day > 4 ->
        days_to_add = 8 - day
        Date.add(today, days_to_add)
      _ -> Date.add(today, 1)
    end
    {:ok, next_day}
  end

  defp no_lunch_choosen, do: {"""
  *You haven't choose any lunch for today :disappointed_relieved:*
  """}
end
