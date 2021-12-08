defmodule Keyblade.Reservations.SearchParams do
  @required_fields [
    :start_date,
    :end_date,
    :start_time,
    :end_time,
    :party_size_min,
    :party_size_max,
    :restaurant_id,
    :interval,
    :notify_number
  ]

  @optional_fields [
    :restaurant_name,
    queries: []
  ]

  @enforce_keys @required_fields
  defstruct @required_fields ++ @optional_fields

  def new(attrs \\ %{}) do
    struct!(__MODULE__, attrs)
  end
end
