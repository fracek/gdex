defmodule Gdex.Mixfile do
  use Mix.Project

  @version "0.1.1"
  @source_url "https://github.com/fracek/gdex"

  def project do
    [app: :gdex,
     version: @version,
     elixir: "~> 1.4",
     name: "Gdex",
     package: package(),
     start_permanent: Mix.env == :prod,
     test_coverage: [tool: ExCoveralls],
     deps: deps(),
     docs: docs(),
     description: description(),
     source_url: @source_url]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [{:httpoison, "~> 1.0"},
     {:poison, "~> 3.0"},
     {:websocket_client, "~> 1.3.0"},
     {:dialyze, "~> 0.2", only: :dev, runtime: false},
     {:ex_doc, "~> 0.16", only: :dev, runtime: false},
     {:mock, "~> 0.3.1", only: :test},
     {:excoveralls, "~> 0.7", only: :test}]
  end

  defp package do
    %{licenses: ["Apache 2.0"],
      maintainers: ["Francesco Ceccon"],
      links: %{"GitHub": @source_url}}
  end

  defp docs do
    [main: "Gdex", source_ref: "v#{@version}", source_url: @source_url]
  end

  defp description do
    "REST and Websocket client for GDAX Exchange"
  end
end
