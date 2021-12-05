defmodule Keyblade.Parks.QueryParams do
  @fields [
    :restaurant_id,
    :party_size,
    :date,
    :time
  ]

  @enforce_keys @fields
  defstruct @fields

  def new(attrs \\ %{}) do
    struct!(__MODULE__, attrs)
  end
end
