defmodule JunkTest do
  use ExUnit.Case
  doctest Junk

  test "no args defaults .junk to String" do
    output = Junk.junk(String)
    assert is_binary(output) == true
    assert String.printable?(output) == true
    assert output != Junk.junk(String)
  end

  test "only options defaults .junk to String with options" do
    output = Junk.junk(String, byte_size: 5)
    assert is_binary(output) == true
    assert String.printable?(output) == true
    assert output != Junk.junk(String, byte_size: 5)
  end

  test "returns unique Strings" do
    output = Junk.junk(String)
    assert is_binary(output) == true
    assert String.printable?(output) == true
    assert output != Junk.junk(String)
  end

  test "returns Strings with an optional prefix" do
    output = Junk.junk(String, prefix: "prefix")
    assert String.starts_with?(output, "prefix-")
  end

  test "returns unique Integers" do
    assert Junk.junk(Integer) |> is_integer == true
    assert Junk.junk(Integer) != Junk.junk(Integer)
  end

  test "returns Integers to optional unit size" do
    digits = Junk.junk(Integer, size: 25) |> Integer.digits
    assert Kernel.length(digits) == 25
  end

  test "returns arbitrarily large Integers" do
    digits = Junk.junk(Integer, size: 2048) |> Integer.digits
    assert Kernel.length(digits) == 2048
  end
end
