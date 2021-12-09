defmodule Keyblade.MixProject do
  use Mix.Project

  def project do
    [
      app: :keyblade,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Keyblade.Application, []},
      applications: [:req, :timex, :sms_blitz],
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:req, "~> 0.2"},
      {:timex, "~> 3.7"},
      {:sms_blitz, "~> 0.1.1"}
    ]
  end
end
