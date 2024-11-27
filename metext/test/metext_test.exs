defmodule MetextTest do
  use ExUnit.Case
  doctest Metext

  test "greets the world" do
    assert Metext.hello() == :world
  end
end
