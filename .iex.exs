alias Keyblade.Parks
alias Keyblade.Parks.DisneyWorld
alias Keyblade.Reservations.SearchParams

search_params = %SearchParams{
  end_date: Date.new!(2022, 01, 18),
  end_time: Time.new!(21, 15, 0),
  party_size_max: 8,
  party_size_min: 4,
  start_date: Date.new!(2022, 01, 13),
  start_time: Time.new!(15, 30, 0)
}
