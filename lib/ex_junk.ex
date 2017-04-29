defmodule Junk do
  @moduledoc """
  Junk is a module for generating Junk data.
  It is inspired by Dave Brady's [rspec-junklet](https://github.com/dbrady/rspec-junklet)
  """

  @chars "abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ" |> String.split("", trim: true)

  defstruct byte_size: 32,
    prefix: false,
    rand_mod: &Enum.random/1,
    size: 16,
    presets: Application.get_all_env(:ex_junk),
    parameters: [],
    unique: false

  @doc """
  Takes a Module (String, Integer) and options, returns junk for that Module.
  """
  def junk(_ \\ String, opts \\ [])

  def junk(opts, _) when is_list(opts) do
    junk(String, opts)
  end

  def junk(String, opts) do
    pick_one(&generate_string/1, opts)
  end

  def junk(Integer, opts) do
    pick_one(&generate_integer/1, opts)
  end

  def junk(f, opts) when is_function(f) do
    pick_one(fn(opts) -> 
      apply(f, opts.parameters)
    end, opts)
  end

  def junk(preset_name, opts) when is_atom(preset_name) do
    opts = construct_opts(opts)
    case get_in(opts, [:presets, preset_name]) do
      f when is_function(f) -> Junk.junk(f, opts)
      params when is_list(params) -> apply(Junk, :junk, params)
      _ -> Junk.junk(String, %{opts | prefix: Atom.to_string(preset_name)})
    end
  end

  defp pick_one(generator, opts) do
    opts = construct_opts(opts)
    Stream.repeatedly(fn -> generator.(opts) end)
    |> Stream.map(&post_op(&1, opts))
    |> Stream.filter(&filter(&1, opts))
    |> Enum.take(1)
    |> List.first
  end

  def generate_string(opts) do
    Enum.reduce(1..opts.byte_size, [], fn(_i, acc) -> [opts.rand_mod.(@chars) | acc] end)
    |> Enum.join("")
  end

  defp generate_integer(opts) do
    min = :math.pow(10, opts.size-1) |> trunc
    max = :math.pow(10, opts.size)-1 |> trunc
    Range.new(min, max) 
    |> Enum.random
  end

  defp construct_opts(opts) do
    Enum.into(opts, Map.from_struct(%Junk{}))
  end

  defp post_op(output, opts) do
    if opts.prefix, do: "#{opts.prefix}-#{output}", else: output
  end

  defp filter(value, opts) do
    if opts.unique, do: unique?(value), else: true
  end

  defp unique?(value) do
    if :ets.info(:used_junk) == :undefined do
      :ets.new(:used_junk, [:named_table])
    end
    :ets.insert_new(:used_junk, {value})
  end

end
