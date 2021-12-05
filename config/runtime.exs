import Config

nexmo_account_key =
  System.get_env("NEXMO_API_KEY") ||
    raise "NEXMO_API_KEY not available"

nexmo_account_secret =
  System.get_env("NEXMO_API_SECRET") ||
    raise "NEXMO_API_SECRET not available"

nexmo_number =
  System.get_env("NEXMO_NUMBER") ||
    raise "NEXMO_NUMBER not available"

notify_number =
  System.get_env("NOTIFY_NUMBER") ||
    raise "NOTIFY_NUMBER not available"

config :sms_blitz,
  nexmo: {nexmo_account_key, nexmo_account_secret},
  nexmo_number: nexmo_number,
  notify_number: notify_number
