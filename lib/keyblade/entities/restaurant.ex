defmodule Keyblade.Entities.Restaurant do
  alias Keyblade.Entities.Entity

  @required_fields [:id, :name]
  @optional_fields []

  @enforce_keys @required_fields
  defstruct @required_fields ++ @optional_fields

  @entity_type "restaurant"

  def type do
    @entity_type
  end

  def new(%Entity{id: id, name: name, type: @entity_type}) do
    struct!(__MODULE__, %{id: id, name: name})
  end

  def new(_) do
    raise "Must be a #{@entity_type} entity"
  end
end
