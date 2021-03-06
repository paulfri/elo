defmodule Elo.Mixfile do
  use Mix.Project

  def project do
    [app: :elo,
     version: "0.1.0",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     description: description(),
     package: package()]
  end

  def application do
    []
  end

  defp deps do
    [{:ex_doc, ">= 0.0.0", only: :dev},
     {:credo, "~> 0.4", only: [:dev, :test]},
     {:inch_ex, ">= 0.0.0", only: :docs}]
  end

  defp description do
  """
  Calculate Elo ratings.
  """
  end

  defp package do
    [name: :elo,
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/paulfri/elo"},
     maintainers: ["Paul Friedman"]]
  end
end
