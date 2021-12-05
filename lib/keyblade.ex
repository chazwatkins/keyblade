defmodule Keyblade do
  defdelegate check_for_available_reservations(provider, search_params),
    to: Keyblade.Parks
end
