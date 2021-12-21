defmodule Keyblade.Core.Reservations.Reservation do
  @required_fields [:datetime]
  @optional_fields []

  @enforce_keys @required_fields
  defstruct @required_fields ++ @optional_fields
end
