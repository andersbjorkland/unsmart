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
    features = a * b

    Axon.input("input", shape: {batches, features})
    |> Axon.dense(256, activation: :relu)
    |> Axon.batch_norm()
    |> Axon.dropout(rate: 0.8)
    |> Axon.dense(128, activation: :tanh)
    |> Axon.dense(10, activation: :softmax)
  end

  def train() do
    a = 100
    b = 100
    max_padding = (100 * 100) |> Integer.digits(2) |> length()

    loop =
      raw_model()
      |> Axon.Loop.trainer(:log_cosh, Polaris.Optimizers.adamw(learning_rate: 0.05))

    # train_data = [raw_train_data()] |> Nx.tensor()
    raw_targets_data(a, b)
    |> Enum.map(fn
      list when length(list) < max_padding ->
        nil
    end)

    targets_data = [raw_targets_data()] |> Nx.tensor()
    # data = Stream.zip(train_data, targets_data)
    # params = Axon.Loop.run(loop, data, %{}, iterations: 10000, epochs: 5)
  end

  def pad_list(list, _value, length) when length(list) == length, do: list
  def pad_list(list, value, length), do: pad_list([value | list], value, length)
end
