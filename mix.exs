defmodule Gdex.Mixfile do
  use Mix.Project

  def project do
    [app: :gdex,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     name: "Gdex",
     source_url: "https://github.com/fracek/gdex"]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [{:httpoison, "~> 0.13"},
     {:poison, "~> 3.0"},
     {:dialyze, "~> 0.2", only: :dev, runtime: false},
     {:ex_doc, "~> 0.16", only: :dev, runtime: false}]
  end
end
