defmodule Keyblade.Reservations.SearchParams do
  @fields [
    :start_date,
    :end_date,
    :start_time,
    :end_time,
    :party_size_min,
    :party_size_max
  ]

  @enforce_keys @fields
  defstruct @fields

  def new(attrs \\ %{}) do
    struct!(__MODULE__, attrs)
  end
end
