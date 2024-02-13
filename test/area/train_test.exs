defmodule Unsmart.Area.TrainTest do
  use ExUnit.Case

  alias Unsmart.Area.Train

  describe "raw_train_data/2" do
    test "can get train data with dimensions" do
      data = Train.raw_train_data(3, 3)

      three = [1, 1]
      two = [1, 0]
      one = [1]

      expected = [
        [one, one],
        [one, two],
        [one, three],
        [two, one],
        [two, two],
        [two, three],
        [three, one],
        [three, two],
        [three, three]
      ]

      assert expected == data
    end
  end

  describe "raw_target_data/2" do
    test "can get target data for dimensions" do
      data = Train.raw_targets_data(3, 3)

      nine = [1, 0, 0, 1]
      six = [1, 1, 0]
      four = [1, 0, 0]
      three = [1, 1]
      two = [1, 0]
      one = [1]

      expected = [
        # 1 * 1
        one,
        # 1 * 2
        two,
        # 1 * 3
        three,
        # 2 * 1
        two,
        # 2 * 2
        four,
        # 2 * 3
        six,
        # 3 * 1
        three,
        # 3 * 2
        six,
        # 3 * 3
        nine
      ]

      assert expected == data
    end
  end
end

# [
#   [[[1], [1]]], [[[1], [1, 0]]], [[[1, 0], [1]]], [[[1, 0], [1, 0]]]
# ]
