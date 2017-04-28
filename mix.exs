defmodule Junk.Mixfile do
  use Mix.Project
  @version "0.1.0"

  def project do
    [app: :ex_junk,
     version: @version,
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     description: description(),
     package: package(),
     docs: [
       extras: ["README.md"],
       main: "readme",
       source_ref: "v#{@version}",
       source_url: "https://github.com/felix-starman/ex_junk",
     ]
   ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    []
  end

  defp description do
    """
    Junk is a module for generating Junk data in your tests.
    For when you don't care about the content, just that it has the right 'shape'.
    """
  end

  defp package do
    [# These are the default files included in the package
     name: :ex_junk,
     files: ["lib", "mix.exs", "README*", "LICENSE*"],
     maintainers: ["Peter Mueller"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/felix-starman/ex_junk",
      "Docs" => "https://github.com/felix-starman/ex_junk"}]
  end
end
