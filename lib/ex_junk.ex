defmodule Junk do
  @moduledoc """
  Junk is a module for generating Junk data.
  It is inspired by Dave Brady's [rspec-junklet](https://github.com/dbrady/rspec-junklet)
  """

  defstruct byte_size: 32,
    prefix: false,
    rand_mod: &:crypto.strong_rand_bytes/1,
    size: 16,
    presets: Application.get_all_env(:ex_junk),
    parameters: []

  @doc """
  Takes a Module (String, Integer) and options, returns junk for that Module.
  """
  def junk(_ \\ String, opts \\ [])

  def junk(opts, _) when is_list(opts) do
    junk(String, opts)
  end

  def junk(String, opts) do
    opts = construct_opts(opts)
    string = opts.rand_mod.(opts.byte_size)
    |> Base.url_encode64
    post_op(string, opts)
  end

  def junk(Integer, opts) do
    opts = construct_opts(opts)
    min = :math.pow(10, opts.size-1) |> trunc
    max = :math.pow(10, opts.size)-1 |> trunc
    output = Range.new(min,max) |> Enum.random
    post_op(output, opts)
  end

  def junk(:long_npi, opts) do
    opts = construct_opts(opts)
    |> Map.put(:size, 8)
    # grab 8 digits, and put a 1 or 2 on the front
    junk(Integer, opts)
    |> Integer.digits
    |> (fn digits -> [8,0,8,4,0] ++ [Enum.random(1..2)] ++ digits end).()
    |> Integer.undigits
    |> Junk.luhn
  end

  def junk(:npi, opts) do
    junk(:long_npi, opts) - trunc(80840 * :math.pow(10, 10))
  end

  def junk(f, opts) when is_function(f) do
    opts = construct_opts(opts)
    apply(f, opts.parameters)
  end

  def junk(preset_name, opts) when is_atom(preset_name) do
    opts = construct_opts(opts)
    case get_in(opts, [:presets, preset_name]) do
      f when is_function(f) -> Junk.junk(f, opts)
      params when is_list(params) -> apply(Junk, :junk, params)
      _ -> Junk.junk(String, prefix: Atom.to_string(preset_name))
    end
  end

  def luhn(number) do
    base_digits = Integer.digits(number)
    check_sum = base_digits
    |> Enum.reverse
    |> Junk.map_every(2, fn(n) ->Integer.digits(n*2) end)
    |> List.flatten
    |> Enum.sum

    # calcs the check digit
    check_digit = case Kernel.rem(check_sum, 10) do
      0 -> 0
      n -> 10 - n
    end

    (base_digits ++ [check_digit]) |> Integer.undigits
  end

  def map_every(enumerable, nth, mapper) do
    {res, _acc} = Enum.map_reduce(enumerable, 0, fn(x, i) -> if (rem(i, nth) == 0) do
        {mapper.(x), i+1}
      else
        {x, i+1}
      end
    end)
    res
  end

  defp construct_opts(opts) do
    Enum.into(opts, Map.from_struct(%Junk{}))
  end

  defp post_op(output, opts) do
    if opts.prefix, do: "#{opts.prefix}-#{output}", else: output
  end
end
