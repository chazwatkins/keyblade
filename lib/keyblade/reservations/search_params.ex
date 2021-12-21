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
    :user_id
  ]

  @optional_fields [
    queries: []
  ]

  @enforce_keys @required_fields
  defstruct @required_fields ++ @optional_fields

  def new(attrs \\ %{}) do
    struct!(__MODULE__, attrs)
  end
end
