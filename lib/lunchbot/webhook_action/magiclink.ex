defmodule Lunchbot.WebhookAction.Magiclink do
  @moduledoc false

  def perform(webhook = %Lunchbot.Webhook{params: params}) do
    with {:ok, magiclink} <- get_magiclink(params),
         {:ok, user} <- get_or_create_user(webhook),
         {:ok, user} <- Lunchbot.Repo.Users.update_magic_link(user, magiclink)
      do
      Task.async(fn -> update_session_for_magiclink(user) end)
      {:ok, put_in(webhook.response.blocks, [response_json])}
    else
      {:error, error} -> {:error, %{webhook | error: error}}
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
  def get_magiclink(params) when is_binary(params) do
    with %{host: "airhelp.lunchroom.pl", scheme: "https", path: path} <- URI.parse(params),
         String.starts_with?(path, "/autoLogin/") do
      {:ok, params}
    else
      _ ->
      get_magiclink(nil)
    end
  end

  def get_magiclink(params = [magiclink | _]) when is_list(params) do
    get_magiclink(magiclink)
  end
  def  get_magiclink(_), do: {:error, :no_magic_link}


  @doc """
  Create user or take it from webhook if it is already in db
  """
  def get_or_create_user(%Lunchbot.Webhook{user: %Lunchbot.Repo.Users.User{} = user}), do: {:ok, user}
  def get_or_create_user(%Lunchbot.Webhook{slack_data: slack_data = %{}}) do
    case Lunchbot.Repo.Users.create_user(slack_data) do
      {:ok, user} -> {:ok, user}
      _ -> {:error, :user_not_created}
    end
  end

  @doc """
  Updates magiclink for given user
  """
  def update_magiclink(user, magiclink) do
    case Lunchbot.Repo.Users.update_magic_link(user, magiclink) do
      {:ok, user} -> {:ok, user}
      _ -> {:error, :magic_link_not_updated}
    end
  end

  def update_session_for_magiclink(user), do: Lunchbot.Lunchroom.refresh_session_for_user(user)

  def response_json, do:  """
        *Magic link updated :male_mage:*

        Now you can send `/lunch`
      """

end
