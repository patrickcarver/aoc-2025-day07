defmodule Day07Test do
  use ExUnit.Case

  @test_file "priv/test.txt"
  @input_file "priv/input.txt"

  test "ensuring outputs return correct value" do
    assert Day07.part1(@test_file) == 21
    assert Day07.part1(@input_file) == 1658
    assert Day07.part2(@test_file) == 40
    assert Day07.part2(@input_file) == 53_916_299_384_254
  end
end
