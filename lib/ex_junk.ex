defmodule Junk do
  @moduledoc """
  Junk is a module for generating Junk data.
  It is inspired by Dave Brady's [rspec-junklet](https://github.com/dbrady/rspec-junklet)
  """

  @inject %{random_bytes: &:crypto.strong_rand_bytes/1}

  @default_opts [
    byte_size: 32,
    prefix: "",
    rand_mod: @inject,
    size: 16
  ]

  @doc """
  Returns junk(String).
  """
  def junk, do: junk(String, @default_opts)

  @doc """
  Returns junk(String, opts)
  """
  def junk(opts) when is_list(opts) do
    junk(String, opts)
  end

  @doc """
  Takes a Module (String, Integer), and options, returns junk for that Module.
  """
  def junk(junk_type, opts \\ @default_opts) do
    merged_opts = @default_opts
    |> Keyword.merge(opts)
    |> Enum.into(%{})
    junk_for_type(junk_type, merged_opts)
  end

  defp junk_for_type(:"Elixir.String", opts) do
    string = random_bytes(opts)
    |> Base.url_encode64
    opts.prefix <> "-" <> string
  end

  defp junk_for_type(:"Elixir.Integer", opts) do
    min = pow(10, opts.size - 1)
    max = pow(10, opts.size) - 1

    :crypto.rand_uniform(min, max)
  end

  defp random_bytes(%{rand_mod: rand_mod, byte_size: b_size}) do
    rand_mod.random_bytes.(b_size)
  end

  defp pow(_base, 0), do: 1
  defp pow(base, exp) when rem(exp, 2) == 1, do: base * pow(base, exp - 1)
  defp pow(base, exp) do
    result = pow(base, div(exp, 2))
    result * result
  end
end
