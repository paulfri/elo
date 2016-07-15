defmodule Elo do
  @moduledoc """
  The `Elo` module is used to calculate Elo ratings.

  The [Elo rating system](https://en.wikipedia.org/wiki/Elo_rating_system) is
  used to represent relative skill levels in head-to-head competitive games. A
  "match" pairs two ratings along with a result (win, loss, or draw); based
  on the expected result, points are transferred between the two parties.

  The point exchange in an Elo match is always zero-sum (all points subtracted
  from one party are awarded to the other); therefore, it is not possible to
  improve a rating with a loss. A larger difference between the actual and
  expected result will result in a larger point transfer (e.g., an "upset,"
  where the heavily favored rating loses).

  ## K-factor

  The "K-factor" is a constant applied in the Elo formula that determines the
  sensitivity (amount of swing) in a given match. The higher the k-factor, the
  more points will be exchanged.

  Generally, the K-factor can decrease over time as a rating approaches its
  "true" value. For now, this module only supports a constant K-factor of 25.
  """

  @k_factor 25

  @doc """
  Calculate new Elo ratings for two given existing ratings (`player` and
  `opponent`) and a given `result`.

  Result must be :win (first rating wins), :draw (a draw), or :loss (first
  rating loses). These are converted to the Elo values 1.0, 0.5, and 0.0,
  respectively.

  ## Examples

      iex(1)> Elo.rate(1000, 500, :win)
      {1001.3310053800506, 498.66899461994944}
      iex(1)> Elo.rate(1000, 500, 1.0)
      {1001.3310053800506, 498.66899461994944}
      iex(2)> Elo.rate(1000, 500, :loss)
      {976.3310053800506, 523.6689946199494}
      iex(3)> Elo.rate(1000, 1000, :draw)
      {1.0e3, 1.0e3}
  """
  def rate(player, opponent, :win),  do: rate(player, opponent, 1.0)
  def rate(player, opponent, :loss), do: rate(player, opponent, 0.0)
  def rate(player, opponent, :draw), do: rate(player, opponent, 0.5)
  def rate(player, opponent, result) when result in [0.0, 0.5, 1.0] do
    {new_rating(player, opponent, result),
     new_rating(opponent, player, 1.0 - result)}
  end

  @doc """
  Calculate the expected result for the given `player` and `opponent` ratings.

  The expected result is expressed as a winning percentage (probability that
  `player` will win, plus half the probability of a draw).

  ## Examples

      iex(1)> Elo.expected_result(1000, 500)
      0.9467597847979775
  """
  def expected_result(player, opponent) do
    1.0 / (1.0 + (:math.pow(10.0, ((opponent - player) / 400.0))))
  end

  defp new_rating(player, opponent, result) do
    player
    |> expected_result(opponent)
    |> elo_change(result)
    |> elo_result(player)
  end

  defp elo_change(expected_result, result) do
    @k_factor * (result - expected_result)
  end

  defp elo_result(change, original) do
    change + original
  end
end
