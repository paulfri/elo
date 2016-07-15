# Elo [![Build Status](https://travis-ci.org/paulfri/elo.svg?branch=travis)](https://travis-ci.org/paulfri/elo) [![Inline docs](http://inch-ci.org/github/paulfri/elo.svg)](http://inch-ci.org/github/paulfri/elo) [![Deps Status](https://beta.hexfaktor.org/badge/all/github/paulfri/elo.svg)](https://beta.hexfaktor.org/github/paulfri/elo) [![Hex.pm](https://img.shields.io/hexpm/v/elo.svg?maxAge=2592000)]()

Calculate Elo ratings.

```elixir
iex(1)> Elo.rate(1000, 500, :win)
{1001.3310053800506, 498.66899461994944}
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
