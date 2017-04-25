defmodule LoggerLager.Mixfile do
  use Mix.Project

  def project do
    [app: :logger_lager,
     description: "Logger backend that forwards messages to lager",
     version: "0.1.2",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     package: package(),
     deps: deps()]
  end

  defp package do
    [maintainers: ["Yuri Artemev", "Jonathan Perret"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/artemeff/logger_lager"},
     files: ["lib", "mix.exs", "README.md", "LICENSE"]]
  end

  def application do
    [applications: [:lager, :logger]]
  end

  defp deps do
    [{:lager, ">= 3.2.0", optional: true},
     {:ex_doc, ">= 0.0.0", only: :dev}]
  end
end
