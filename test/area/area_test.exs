defmodule Unsmart.Area.AreaTest do
  use ExUnit.Case

  alias Unsmart.Area.Area

  describe "dimensions/1" do
    test "gets dimensions for an area" do
      dimensions = Area.dimensions(3, 2)

      expected = [
        [1, 1],
        [1, 0]
      ]

      assert expected == dimensions
    end

    test "gets dimensions for a larger area" do
      dimensions = Area.dimensions(123, 2)

      expected = [
        [1, 1, 1, 1, 0, 1, 1],
        [1, 0]
      ]

      assert expected == dimensions
    end
  end

  describe "area_helper_parser/1" do
    test "can convert binary from list to integer" do
      number = Area.area_helper_parser([1, 1, 1, 1, 0, 1, 1])

      assert 123 == number
    end
  end

  describe "target/1" do
    test "returns binary list for provided dimensions" do
      area_binary_list = Area.target(3, 3)

      assert [1, 0, 0, 1] == area_binary_list
    end
  end

  # test "area_helper can parse list of varied length" do
  #   input = [0, 0, 0, 0, 0, 0, 1, 0, 0]

  #   assert 7 == Area.area_helper_parser(input)
  # end
end
