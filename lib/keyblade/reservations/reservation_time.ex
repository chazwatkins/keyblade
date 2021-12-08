defmodule Keyblade.Reservations.ReservationTime do
  @required_fields [
    :datetime,
    :party_size
  ]

  @optional_fields []

  @enforce_keys @required_fields
  defstruct @required_fields ++ @optional_fields

  def new(attrs \\ %{}) do
    struct(__MODULE__, attrs)
  end
end
