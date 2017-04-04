defmodule Junk do
  @moduledoc """
  Junk is a module for generating Junk data.
  It is inspired by Dave Brady's [rspec-junklet](https://github.com/dbrady/rspec-junklet)
  """

  @inject %{random_bytes: &:crypto.strong_rand_bytes/1}

  @default_opts %{
    rand_mod: @inject,
    length: 16
  }

  @doc """
  Returns junk.
  """
  def junk, do: junk(String, @default_opts)
  def junk(opts) when is_map(opts) do
    junk(String, merged_opts(opts))
  end
  def junk(junk_type, opts \\ @default_opts) do
    new_opts = merged_opts(opts)
    bytes = random_bytes(new_opts)
    junk_for_type(junk_type, bytes, new_opts)
  end

  defp junk_for_type(:"Elixir.String", bytes, _opts) do
    bytes |> Base.url_encode64
  end
  defp junk_for_type(:"Elixir.Integer", _bytes, opts) do
    min = :math.pow(10, opts.length-1) |> trunc
    max = :math.pow(10, opts.length)-1 |> trunc
    Range.new(min,max) |> Enum.random
  end

  defp random_bytes(%{length: length, rand_mod: rand_mod}) do
    rand_mod.random_bytes.(length)
  end

  defp merged_opts(opts) do
    Map.merge(@default_opts, opts)
  end
end
