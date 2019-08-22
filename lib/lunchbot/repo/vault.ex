defmodule Lunchbot.Repo.Vault do
  use Cloak.Vault, otp_app: :lunchbot


  @impl GenServer
  def init(config) do
    config =
      Keyword.put(config, :ciphers, [
        default: {Cloak.Ciphers.AES.GCM, tag: "AES.GCM.V1", key: decode_env!(:cloak_key)}
      ])

    {:ok, config}
  end

  defp decode_env!(var) do
    :lunchbot
    |> Application.fetch_env!(var)
    |> Base.decode64!()
  end
end
