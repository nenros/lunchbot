defmodule Lunchbot.Command.Lunch.Magiclink do
  alias Lunchbot.Repo.Users
  alias Lunchbot.Repo.Users.User

  require Logger

  def perform(params) do
    with {:ok, url} <- get_magiclink(params["text"]),
         {:ok, user} <- update_user_magiclink(params, url),
         {:ok, _user} <- update_session_for_magiclink(user) do
      {:ok, response_json()}
    else
      {:error, :no_magic_link = error} ->
        Logger.info("No magic link found in params")
        {:ok, error_json(error)}

      {:error, error} ->
        Logger.warn("Errror found: #{error}")
        {:error, error}
    end
  end

  @doc """
  Check if string is magiclink. Needs to be https and in correct subdomain.

  ## Examples
    iex> Lunchbot.Command.Lunch.Magiclink.get_magiclink("magiclink https://airhelp.lunchroom.pl/autoLogin/params")
    {:ok, "https://airhelp.lunchroom.pl/autoLogin/params"}

    iex> Lunchbot.Command.Lunch.Magiclink.get_magiclink("magiclink something not link")
    {:error, :no_magic_link}
  """
  def get_magiclink(<<"magiclink", rest::binary>>) when byte_size(rest) > 0 do
    with url <- String.trim(rest),
         %{host: "airhelp.lunchroom.pl", scheme: "https", path: path} <- URI.parse(url),
         String.starts_with?(path, "/autoLogin/") do
      Logger.debug("Magiclink found in #{rest}")
      {:ok, url}
    else
      _ ->
        Logger.warn("No magiclink found in '#{rest}'")
        get_magiclink(nil)
    end
  end

  def get_magiclink(_), do: {:error, :no_magic_link}

  @doc """
  Create user or take it from webhook if it is already in db
  """

  def update_user_magiclink(params, magiclink) do
    case Lunchbot.Repo.Users.find_user_by_user_id(params["user_id"]) do
      user = %User{} ->
        Logger.debug("User with id: #{user.user_id} found, updating magiclink")
        Users.update_magic_link(user, magiclink)

      nil ->
        Logger.debug("User with id: #{params["user_id"]} need to be created")

        params
        |> Map.put("magiclink", magiclink)
        |> Users.create_user()

      _ ->
        {:error, :user_not_created}
    end
  end

  def update_session_for_magiclink(user) do
    with {:ok, session_id} <- Lunchbot.Lunchroom.get_session_from_magiclink(user.magiclink),
         {:ok, user} <- Lunchbot.Repo.Users.save_session_id(user, session_id) do
      Logger.debug("Updated session for user: #{user.user_id}")
      {:ok, :ok}
    end
  end

  def error_json(:no_magic_link),
    do: """
      *Magic link cannot be find in command parameters*

      #{Lunchbot.Command.Lunch.Help.how_to_get_magic_link()}

      #{Lunchbot.Command.Lunch.Help.magic_link_format()}
    """

  def response_json,
    do: """
      *Magic link updated :male_mage:*

      Now you can send `/lunch`
    """
end
