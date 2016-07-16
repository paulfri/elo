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
  more points will be exchanged. Generally, the K-factor can decrease over time
  as a rating approaches its "true" value.
  """

  @default_k_factor 24

  @doc """
  Calculate new Elo ratings for two given existing ratings (`player` and
  `opponent`) and a given `result`.

  Result must be `:win` (first rating wins), `:draw` (a draw), or `:loss` (first
  rating loses). These are converted to the Elo values 1.0, 0.5, and 0.0,
  respectively. You can also pass the numeric value directly.

  Available options for `opts`:

  * `round`: One of `:up`, `:down`, or `true` (half-up), or `false`. By default,
  rounding occurs only when both `player` and `opponent` are passed as integers.
  Using the `up` or `down` method consistently will lead to point drift, as
  point exchange is no longer zero-sum.
  * `k_factor`: Value to use for the K-factor (see module documentation for an
   explanation). If not specified, `@default_k_factor` is used.

  ## Examples

      iex> Elo.rate 1600, 1200, :win
      {1602, 1198}
      iex> Elo.rate 1238.0, 1656.5, :loss
      {1236.0204093743623, 1658.4795906256377}
      iex> Elo.rate 1238.0, 1656.5, 0.0, round: true
      {1236, 1658}
  """
  def rate(player, opponent, result, opts \\ [])
  def rate(player, opponent, result, opts) when is_integer(player) and is_integer(opponent) do
    # Since both `player` and `opponent` are ints, ensure that the ratings we
    # return are also ints (unless rounding is explicitly disabled). We also
    # convert both ratings to floats (via division operator) to avoid calling
    # this function body again.
    rate(player / 1, opponent / 1, result, Keyword.merge([round: true], opts))
  end
  def rate(player, opponent, :win,   opts), do: rate(player, opponent, 1.0, opts)
  def rate(player, opponent, :loss,  opts), do: rate(player, opponent, 0.0, opts)
  def rate(player, opponent, :draw,  opts), do: rate(player, opponent, 0.5, opts)
  def rate(player, opponent, result, opts) when result in [0.0, 0.5, 1.0] do
    {calculate(player,   opponent, result,       opts),
     calculate(opponent, player,   1.0 - result, opts)}
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

  defp calculate(player, opponent, result, opts) do
    player
    |> expected_result(opponent)
    |> change(result, opts[:k_factor])
    |> score(player, opts[:round])
  end

  defp change(expected_result, result, nil) do
    change(expected_result, result, @default_k_factor)
  end

  defp change(expected_result, result, k_factor) do
    k_factor * (result - expected_result)
  end

  defp score(change, original, round_strategy) do
    change
    |> (&(&1 + original)).()
    |> round(round_strategy)
  end

  defp round(result, strategy) do
    case strategy do
      :down -> result |> Float.floor |> round
      :up   -> result |> Float.ceil  |> round
      true  -> result |> round
      _     -> result
    end
  end
end
