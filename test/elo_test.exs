defmodule EloTest do
  use ExUnit.Case
  doctest Elo

  @player   1000.0
  @opponent 900.0

  @player_i   1000
  @opponent_i 900

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

  test "rounds results when passing integers" do
    {player, opponent} = Elo.rate(@player_i, @opponent_i, :win)

    assert player   == 1009
    assert opponent == 891
  end

  test "rounds up with `round: :up` option" do
    {player, opponent} = Elo.rate(@player, @opponent, :win, round: :up)

    assert player   == 1009
    assert opponent == 892
  end

  test "rounds down with `round: :down` option" do
    {player, opponent} = Elo.rate(@player, @opponent, :win, round: :down)

    assert player   == 1008
    assert opponent == 891
  end

  test "does not round with `round: false` option" do
    {player, opponent} = Elo.rate(@player_i, @opponent_i, :win, round: false)

    assert player   == 1008.9983750049279
    assert opponent ==  891.0016249950721
  end
end
