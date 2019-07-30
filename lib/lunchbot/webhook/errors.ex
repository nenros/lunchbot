defmodule Lunchbot.Webhook.Errors do
  require Logger

  def error_to_message(:magic_link_first), do:
    """
     *You have to send magic link first*

    #{Lunchbot.WebhookAction.Help.how_to_get_magic_link()}
    """

  def error_to_message(:no_magic_link), do:
    """
     *This isn't magic link!*

    #{Lunchbot.WebhookAction.Help.magic_link_format()}

    #{Lunchbot.WebhookAction.Help.how_to_get_magic_link()}
    """

  def error_to_message(error) do
    Logger.warn("Found unsupported error: #{error}")
    ":bangbang:Something went wrong, please try again!:bangbang:"
  end
end
