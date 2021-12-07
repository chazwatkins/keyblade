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

config :keyblade,
  searches: [
    %{
      start_date: Date.new!(2022, 01, 13),
      end_date: Date.new!(2022, 01, 18),
      start_time: Time.new!(15, 30, 0),
      end_time: Time.new!(21, 15, 0),
      party_size_min: 4,
      party_size_max: 8,
      restaurant_id: 90_002_606
    },
    %{
      start_date: Date.new!(2022, 01, 13),
      end_date: Date.new!(2022, 01, 18),
      start_time: Time.new!(07, 30, 0),
      end_time: Time.new!(09, 00, 0),
      party_size_min: 4,
      party_size_max: 8,
      restaurant_id: 90_001_369
    }
  ]
