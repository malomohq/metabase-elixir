defmodule Metabase.MixProject do
  use Mix.Project

  def project do
    [
      app: :metabase,
      version: "0.0.0",
      dialyzer: [plt_add_apps: [:hackney]],
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:hackney, "~> 1.18", optional: true},
      {:jason, "~> 1.3", optional: true},
      {:joken, "~> 2.4"},

      # dev

      {:dialyxir, ">= 0.0.0", only: :dev, runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},

      # test

      {:bypass, "~> 2.1", only: :test}
    ]
  end

  defp package do
    %{
      description: "Elixir client for the Metabase API",
      maintainers: ["Anthony Smith"],
      licenses: ["MIT"],
      links: %{
        GitHub: "https://github.com/malomohq/metabase/elixir",
        "Made by Malomo - Post-purchase experiences that customers love": "https://gomalomo.com"
      }
    }
  end
end
