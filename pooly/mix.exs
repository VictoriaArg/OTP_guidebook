defmodule Pooly.MixProject do
  use Mix.Project

  def project do
    [
      app: :pooly,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :wx, :observer],
      ## <- Starts the Pooly application
      mod: {Pooly, []}
    ]
  end

  defp deps do
    []
  end
end
