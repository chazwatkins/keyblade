defmodule Keyblade.Core.Entities.Entity do
  @required_fields [:id, :name, :type]
  @optional_fields []

  @enforce_keys @required_fields
  defstruct @required_fields ++ @optional_fields

  def new(attrs \\ %{}) do
    struct!(__MODULE__, attrs)
  end
end
