defmodule Lunchbot.Command.Lunch.Help do
  @callback run(map) :: {:ok, list} :: {:error, :error}

  def run(_params), do: {:ok, [commands(), how_to_get_magic_link(), magic_link_format()]}

  def commands,
    do: """
      *Posibble commands:*
      - `/lunch`, `/lunch today` - show your today lunch
      - `/lunch tomorrow` - show your lunch for tomorrow
      - `/lunch magiclink <magiclink>` - save your magic link to login
      - `/lunch help` - show that message
    """

  def how_to_get_magic_link,
    do: """
      How to get it?
      - Go to your <https://mail.google.com/mail/u/1/#search/Choose%2C+change+or+cancel+your+lunches|email>
      - Open newest email with with subject `🍽️ Choose, change or cancel your lunches`
      - Click with right click or two fingers on big red button `Click this magic link to login to your account and select lunch`
      - Choose option `Copy link address`
      - Send command `/lunch magiclink <here paste copied link>`
    """

  def magic_link_format,
    do: """
      How it should look like?
      - Should start with `https://`
      - Should be in `airhelp.lunchroom.pl` domain
      - Path should start with `/autoLogin/`
    """
end
