defmodule Keyblade.SMS do
  @nexmo_number Application.get_env(:sms_blitz, :nexmo_number)
  @notify_number Application.get_env(:sms_blitz, :notify_number)

  def send(message) do
    SmsBlitz.send_sms(:nexmo, from: @nexmo_number, to: @notify_number, message: message)
  end
end
