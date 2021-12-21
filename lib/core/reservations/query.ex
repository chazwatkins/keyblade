defmodule Keyblade.Core.Reservations.Query do
  @required_fields [
    :restaurant_id,
    :party_size,
    :date,
    :time
  ]

  @optional_fields [
    :query_string,
    reservation_times: []
  ]

  @enforce_keys @required_fields
  defstruct @required_fields ++ @optional_fields

  def new(attrs \\ %{}) do
    struct!(__MODULE__, attrs)
  end
end
