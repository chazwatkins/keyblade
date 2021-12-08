defmodule Keyblade.SMS do
  require Logger

  def send(message, notify_number) do
    Logger.info("Sending available reservations SMS")
    SmsBlitz.send_sms(:nexmo, from: from_number(), to: notify_number, message: message)
  end

  defp from_number do
    Application.get_env(:sms_blitz, :nexmo_number)
  end
end
