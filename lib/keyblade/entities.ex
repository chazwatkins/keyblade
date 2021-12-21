defmodule Keyblade.Entities do
  alias Keyblade.Entities.{Entity, Restaurant}

  def list_restaurants do
    config_restaurants = Application.get_env(:keyblade, :entities, [])

    config_restaurants
    |> Stream.map(&Entity.new/1)
    |> Stream.filter(fn entity -> entity.type == Restaurant.type() end)
    |> Enum.map(&Restaurant.new/1)
  end

  def get_restaurant_by_id(id) do
    list_restaurants()
    |> Enum.filter(fn restaurant -> restaurant.id == id end)
    |> List.first()
  end
end
