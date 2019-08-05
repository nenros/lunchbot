defmodule Lunchbot.Command.Lunch.Magiclink do
  alias Lunchbot.Repo.Users
  alias Lunchbot.Repo.Users.User

  require Logger

  def perform(params) do
    with {:ok, params} <- get_magiclink(params),
         {:ok, user} <- get_or_create_user(params) do
      Task.async(fn -> update_session_for_magiclink(user) end)
      {:ok, response_json}
    else
      {:error, error} -> {:error,  error}
    end
  end

  @doc """
  Assumes that magic link is first argument in params array

  ## Examples
    iex> Lunchbot.Webhook.Magiclink.get_magiclink(["https://airhelp.lunchroom.pl/autoLogin/params"])
    {:ok, "https://airhelp.lunchroom.pl/autoLogin/params"}

    iex> Lunchbot.Webhook.Magiclink.get_magiclink(["https://airhelp.lunchroom.pl/autoLogin/params", "other params", "next params"])
    {:ok, "https://airhelp.lunchroom.pl/autoLogin/params"}

    iex> Lunchbot.Webhook.Magiclink.get_magiclink("https://airhelp.lunchroom.pl/autoLogin/params")
    {:ok, "https://airhelp.lunchroom.pl/autoLogin/params"}

    iex> Lunchbot.Webhook.Magiclink.get_magiclink("http://airhelp.lunchroom.pl/autoLogin/params")
    {:error, :no_magic_link}

    iex> Lunchbot.Webhook.Magiclink.get_magiclink(1)
    {:error, :no_magic_link}

    iex> Lunchbot.Webhook.Magiclink.get_magiclink([])
    {:error, :no_magic_link}

    iex> Lunchbot.Webhook.Magiclink.get_magiclink(%{})
    {:error, :no_magic_link}
  """
  def get_magiclink(%{"text" => <<"magiclink", rest::binary>>} = params) when byte_size(rest) > 0 do
    with url <- String.trim(rest),
    %{host: "airhelp.lunchroom.pl", scheme: "https", path: path} <- URI.parse(url),
         String.starts_with?(path, "/autoLogin/") do
      {:ok, Map.put(params, "magiclink", url)}
    else
      _ ->
        get_magiclink(nil)
    end
  end

  def get_magiclink(_), do: {:error, :no_magic_link}

  @doc """
  Create user or take it from webhook if it is already in db
  """

  def get_or_create_user(params) do
    case Lunchbot.Repo.Users.find_user_by_user_id(params["user_id"]) do
      user = %User{} ->
        Logger.debug("User with id: #{user.user_id} found, updating magiclink")
        {:ok, Users.update_magic_link(user, params["magiclink"])}
      nil ->
        Logger.debug("User with id: #{params["user_id"]} need to be created")
        {:ok, user} = Users.create_user(params)
      _ ->
        {:error, :user_not_created}
    end
  end

  def update_session_for_magiclink(user), do: Lunchbot.Lunchroom.refresh_session_for_user(user)

  def response_json,
    do: """
      *Magic link updated :male_mage:*

      Now you can send `/lunch`
    """
end
