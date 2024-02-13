defmodule Unsmart.Area.Area do
  def area(a, b), do: a * b

  def dimensions(a, b) do
    [Integer.digits(a, 2), Integer.digits(b, 2)]
  end

  def area_helper_parser(list) do
    Integer.undigits(list, 2)
  end

  def target(a, b) do
    area(a, b) |> Integer.digits(2)
  end
end
