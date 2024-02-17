defmodule Unsmart.Area.Train do
  alias Unsmart.Area.Area

  def raw_train_data(a \\ 100, b \\ 100) when a > 1 and b > 1 do
    for i <- 1..a, j <- 1..b, do: Area.dimensions(i, j)
  end

  def raw_test_data(a \\ 10, b \\ 10) when a > 1 and b > 1 do
    for i <- 1..a, j <- 1..b, do: Area.dimensions(i, j)
  end

  def raw_targets_data(a \\ 100, b \\ 100) do
    for i <- 1..a, j <- 1..b, do: Area.target(i, j)
  end

  def raw_model(a \\ 100, b \\ 100) do
    batches = nil
    features = (a * b) |> Integer.digits(2) |> length()

    Axon.input("input", shape: {batches, features * 2})
    |> Axon.dense(20, activation: :relu)
    |> Axon.batch_norm()
    |> Axon.dropout(rate: 0.8)
    |> Axon.dense(15, activation: :tanh)
    |> Axon.dense(10, activation: :softmax)
  end

  def train() do
    a = 4
    b = 4

    model = raw_model(a, b)

    loop =
      model
      |> Axon.Loop.trainer(
        :categorical_cross_entropy,
        Polaris.Optimizers.adamw(learning_rate: 0.05)
      )

    targets_padding = (a * b) |> Integer.digits(2) |> length()

    targets_data =
      raw_targets_data(a, b)
      |> Enum.map(fn list ->
        pad_list(list, 0, targets_padding)
        |> Enum.concat([pad_list([], 0, targets_padding)])
        |> List.flatten()
        |> list_wrapper()
        |> Nx.tensor()
      end)

    # coord_padding = max(a, b) |> Integer.digits(2) |> length()

    train_data =
      raw_train_data(a, b)
      |> Enum.map(fn coords ->
        Enum.map(coords, fn coord -> pad_list(coord, 0, targets_padding) end)
        |> List.flatten()
        |> list_wrapper()
        |> Nx.tensor()
      end)

    test_data =
      raw_test_data(a, b)
      |> Enum.map(fn coords ->
        Enum.map(coords, fn coord -> pad_list(coord, 0, targets_padding) end)
        |> List.flatten()
        |> list_wrapper()
        |> Nx.tensor()
      end)

    data = Stream.zip(train_data, targets_data)

    params = Axon.Loop.run(loop, data, %{}, iterations: 100, epochs: 5)

    model
    # test_data
    Axon.predict(model, params, test_data, debug: true)
  end

  def pad_list(list, _value, length) when length(list) == length, do: list
  def pad_list(list, value, length), do: pad_list([value | list], value, length)

  defp list_wrapper(element), do: [element]
end
