defmodule Keyblade do
  defdelegate check_for_available_reservations(provider, search_params, restaurant, user),
    to: Keyblade.Parks
end
