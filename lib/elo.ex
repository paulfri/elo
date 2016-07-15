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
  Calculate new Elo ratings for two given existing ratings (`player_rating`
  and `opponent_rating`) and a given `result`.

  Result must be 0.0 (first rating loses), 0.5 (draw), or 1.0 (first rating wins).

  ## Examples

      iex(1)> Elo.rate(1000, 500, 1.0)
      {1001.3310053800506, 498.66899461994944}
  """
  def rate(player, opponent, result) when result in [0.0, 0.5, 1.0] do
    {new_rating(player, opponent, result), new_rating(opponent, player, 1.0 - result)}
  end

  @doc """
  Calculate the expected result for the given `player` and `opponent` ratings.

  The expected result is expressed as a winning percentage (probability that
  `player` will win, plus half the probability of a draw).
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
