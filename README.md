# Elo [![Build Status](https://travis-ci.org/paulfri/elo.svg?branch=travis)](https://travis-ci.org/paulfri/elo) [![Inline docs](http://inch-ci.org/github/paulfri/elo.svg)](http://inch-ci.org/github/paulfri/elo) [![Deps Status](https://beta.hexfaktor.org/badge/all/github/paulfri/elo.svg)](https://beta.hexfaktor.org/github/paulfri/elo) [![Hex.pm](https://img.shields.io/hexpm/v/elo.svg?maxAge=2592000)]()

Calculate Elo ratings.

```elixir
iex> Elo.rate 1200, 1600, :win
{1222, 1578}
```

See the [documentation](https://hexdocs.pm/elo) for usage information.

## Installation

```elixir
def deps do
  [{:elo, "~> 0.1.0"}]
end
```

## TODO

- [ ] adjustable k-factor or k-factor rules per player
