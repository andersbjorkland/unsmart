defmodule UnsmartTest do
  use ExUnit.Case
  doctest Unsmart

  test "greets the world" do
    assert Unsmart.hello() == :world
  end
end
