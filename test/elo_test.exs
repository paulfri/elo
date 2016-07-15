defmodule EloTest do
  use ExUnit.Case
  doctest Elo

  @player   1000
  @opponent 900

  test "win produces correct result" do
    {player, opponent} = Elo.rate(@player, @opponent, :win)

    assert player   == 1008.9983750049279
    assert opponent ==  891.0016249950721
  end

  test "loss produces correct result" do
    {player, opponent} = Elo.rate(@player, @opponent, :loss)

    assert player   == 983.9983750049279
    assert opponent == 916.0016249950721
  end

  test "draw produce correct result" do
    {player, opponent} = Elo.rate(@player, @opponent, :draw)

    assert player   == 996.4983750049279
    assert opponent == 903.5016249950721
  end

  test ".rate can be called directly with result value" do
    {player, opponent} = Elo.rate(@player, @opponent, 1.0)

    assert player   == 1008.9983750049279
    assert opponent ==  891.0016249950721
  end
end
