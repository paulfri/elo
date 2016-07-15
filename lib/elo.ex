defmodule Elo do
  # TODO: adjustable k-factor
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
