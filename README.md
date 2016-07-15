# Elo

Calculate Elo ratings.

```elixir
iex(1)> Elo.rate(1000, 500, 1.0)
# => {1001.3310053800506, 523.6689946199494}
```

## Installation

```elixir
def deps do
  [{:elo, "~> 0.0.1"}]
end
```

## TODO

- [ ] adjustable k-factor
- [ ] adjustable k-factor rules based on experience
- [ ] adjustable rounding rules, or at least an integer return on integer match
- [ ] better interface for win/loss/tie enumerated type; maybe a behavior
