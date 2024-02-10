defmodule Unsmart.Fizz do
  # Divisible by 3, 5, or 3 and 5.
  def fizzbuzz(limit) do
    fizzbuzz(1, limit)
  end

  def fizzbuzz(n, limit, acc \\ "")
  def fizzbuzz(n, limit, acc) when n == limit, do: acc <> " " <> (fizzbuzz_helper(n) |> fizzbuss_wrapper(n))
  def fizzbuzz(n, limit, acc) do
    fizzbuzz(n + 1, limit, acc <> " " <> (fizzbuzz_helper(n) |> fizzbuss_wrapper(n)))
  end

  def fizzbuss_wrapper([_, _, 1, _], _n), do: "FizzBuzz"
  def fizzbuss_wrapper([_, 1, _, _], _n), do: "Buzz"
  def fizzbuss_wrapper([1, _, _, _], _n), do: "Fizz"
  def fizzbuss_wrapper([_, _, _, 1], n), do: "#{n}"

  def fizzbuzz_helper(n) when rem(n, 15) == 0, do: [0, 0, 1, 0]
  def fizzbuzz_helper(n) when rem(n, 5) == 0, do: [0, 1, 0, 0]
  def fizzbuzz_helper(n) when rem(n, 3) == 0, do: [1, 0, 0, 0]
  def fizzbuzz_helper(_n), do: [0, 0, 0, 1]

  def mods(n), do: [rem(n, 3), rem(n, 5), rem(n, 15)]
end
