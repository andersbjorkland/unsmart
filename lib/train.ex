defmodule Unsmart.Train do
  require Unsmart.Fizz

  alias Unsmart.Fizz

  def train_data() do
    # train = for n <- 1..1000, do: Fizz.fizzbuzz_helper(n) |> Nx.tensor
    train = for n <- 1..1000, do: [Fizz.mods(n)] |> Nx.tensor()
    train
  end

  def test_data() do
    test = for(n <- 1..30, do: [Fizz.mods(n)]) |> Nx.tensor()
    test
  end

  def targets_data() do
    targets = for n <- 1..1000, do: [Fizz.fizzbuzz_helper(n)] |> Nx.tensor()
    targets
  end

  def model() do
    batches = nil
    features = 3

    model =
      Axon.input("input", shape: {batches, features})
      |> Axon.dense(10, activation: :tanh)
      |> Axon.dense(4, activation: :softmax)

    model
  end

  def train() do
    # Nx.global_default_backend(EXLA.Backend)

    fizz_model = model()

    loop =
      Axon.Loop.trainer(
        fizz_model,
        :categorical_cross_entropy,
        Polaris.Optimizers.adamw(learning_rate: 0.05)
      )

    fizz_train_data = train_data()
    fizz_target_data = targets_data()
    data = Stream.zip(fizz_train_data, fizz_target_data)

    params = Axon.Loop.run(loop, data, %{}, iterations: 100, epochs: 5)

    convert = fn {label, index} ->
      ~w[fizz buzz fizzbuzz] |> Enum.at(label) |> Kernel.||(index)
    end

    Axon.predict(fizz_model, params, test_data())
    |> Nx.squeeze()
    |> Nx.argmax(axis: 1)
    |> Nx.to_flat_list()
    |> Enum.with_index(1)
    |> Enum.map(convert)
  end

  def basic_shape do
    {xs, _next_key} =
      :rand.uniform(10000)
      |> Nx.Random.key()
      |> Nx.Random.normal(shape: {8, 1})

    {xs, Nx.multiply(xs, 20000) |> Nx.floor()}
  end
end
