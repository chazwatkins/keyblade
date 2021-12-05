defmodule KeybladeTest do
  use ExUnit.Case
  doctest Keyblade

  test "greets the world" do
    assert Keyblade.hello() == :world
  end
end
