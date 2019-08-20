defmodule Lunchbot.Command.Lunch.Lunch do
  @moduledoc false

  alias Lunchbot.Command.Lunch.Help

  def run(params) do
    with {:ok, user} <- get_user(params["user_id"]),
         {:ok, date} <- read_date(params["text"]),
         {:ok, message} <- Lunchbot.Lunchroom.get_lunch_for_date(user.session_id, date) do
      {:ok, message}
    else
      {:error, error = :user_not_found} -> {:ok, get_error_message(error)}
      {:error, error = :wrong_day} -> {:ok, get_error_message(error)}
      {:error, error} -> {:error, error}
    end
  end

  def get_user(user_id) do
    case Lunchbot.Repo.Users.find_user_by_user_id(user_id) do
      %Lunchbot.Repo.Users.User{} = user -> {:ok, user}
      nil -> {:error, :user_not_found}
    end
  end

  def read_date(text) do
    case String.trim(text) do
      "today" ->
        {:ok, get_iso_date(:today)}

      "" ->
        {:ok, get_iso_date(:today)}

      "tomorrow" ->
        {:ok, get_iso_date(:next_working_day)}

      _ ->
        {:error, :wrong_day}
    end
  end

  def get_iso_date(day, date \\ Date.utc_today())

  def get_iso_date(:today, date) do
    Date.to_iso8601(date)
  end

  def get_iso_date(:next_working_day, date) do
    date
    |> get_next_working_day
    |> Date.to_iso8601()
  end

  def get_next_working_day(date) do
    case Date.day_of_week(date) do
      day when day > 4 ->
        days_to_add = 8 - day
        Date.add(date, days_to_add)

      _ ->
        Date.add(date, 1)
    end
  end

  def get_error_message(:user_not_found),
    do: [
      """
      *You have to send magic link first*

      #{Help.how_to_get_magic_link()}
      """
    ]

  def get_error_message(:wrong_day),
    do: [
      """
      *Wrong day!*

      Please write `today` or `tomorrow`. You can also leave empty to get today lunch
      """
    ]
end
