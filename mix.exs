defmodule Labels.MixProject do
  use Mix.Project

  def project do
    [
      app: :labels,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Labels.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Mix tasks to simplify use of Dialyzer in Elixir projects.
      {:dialyxir, "~> 1.0", only: :dev, runtime: false},
      # Security-focused static analysis for the Phoenix framework
      {:sobelow, "~> 0.8", only: :dev},
      # ExDoc is a documentation generation tool for Elixir
      {:ex_doc, "~> 0.27", only: :dev, runtime: false},

      # A static code analysis tool with a focus on code consistency and teaching.
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      # Code coverage
      {:excoveralls, "~> 0.14.6", only: [:dev, :test]},
      # Automatically run tests when files change
      {:mix_test_watch, "~> 1.0", only: [:dev, :test], runtime: false},
      # MixAudit provides a `mix deps.audit` task to scan a project Mix dependencies for known Elixir security vulnerabilities
      {:mix_audit, "~> 2.0", only: [:dev, :test], runtime: false},

      # Factory Bot like
      {:ex_machina, "~> 2.7.0", only: :test},
      # Mocking library
      {:mock, "~> 0.3.0", only: :test},
      # fake http requests
      {:bypass, "~> 2.1", only: :test},
      # Faker is a pure Elixir library for generating fake data.
      {:faker, "~> 0.17", only: :test}
    ]
  end
end
