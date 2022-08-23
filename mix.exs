defmodule MfmParser.MixProject do
  use Mix.Project

  def project do
    [
      app: :mfm_parser,
      version: "0.1.1",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:temple, git: "https://akkoma.dev/AkkomaGang/temple.git", ref: "066a699ade472d8fa42a9d730b29a61af9bc8b59"}
    ]
  end
end
