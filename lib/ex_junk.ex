defmodule Junk do
  @moduledoc """
  Junk is a module for generating Junk data.
  It is inspired by Dave Brady's [rspec-junklet](https://github.com/dbrady/rspec-junklet)
  """

  defstruct byte_size: 32,
    prefix: "",
    rand_mod: &:crypto.strong_rand_bytes/1,
    size: 16

  @doc """
  Takes a Module (String, Integer) and options, returns junk for that Module.
  """
  def junk(_, opts \\ [])

  def junk(opts, _) when is_list(opts) do
    junk(String, opts)
  end

  def junk(String, opts) do
    opts = construct_opts(opts)
    string = opts.rand_mod.(opts.byte_size)
    |> Base.url_encode64
    opts.prefix <> "-" <> string
  end

  def junk(Integer, opts) do
    opts = construct_opts(opts)
    min = :math.pow(10, opts.size-1) |> trunc
    max = :math.pow(10, opts.size)-1 |> trunc
    Range.new(min,max) |> Enum.random
  end

  def junk(regex = %{__struct__: Regex}, opts) do
  end

  defp construct_opts(opts) do
    Enum.into(opts, Map.from_struct(%Junk{}))
  end
end
