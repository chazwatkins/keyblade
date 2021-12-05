defmodule Keyblade.Reservations do
  def generate_queries(provider, search_params) do
    date_range = Date.range(search_params.start_date, search_params.end_date)
    party_range = search_params.party_size_min..search_params.party_size_max

    for _reservation_date <- date_range, party_size <- party_range do
      provider.build_query()
    end
  end
end
