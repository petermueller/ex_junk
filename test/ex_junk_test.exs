defmodule JunkTest do
  use ExUnit.Case
  doctest Junk

  test "no args defaults .junk to String" do
    output = Junk.junk(String)
    assert is_binary(output) == true
    assert String.printable?(output) == true
    assert output != Junk.junk(String)
  end

  test "returns unique Strings" do
    output = Junk.junk(String)
    assert is_binary(output) == true
    assert String.printable?(output) == true
    assert output != Junk.junk(String)
  end

  test "returns unique Integers" do
    assert Junk.junk(Integer) |> is_integer == true
    assert Junk.junk(Integer) != Junk.junk(Integer)
  end

  test "returns Integers to optional unit length" do
    digits = Junk.junk(Integer, %{length: 25}) |> Integer.digits
    assert length(digits) == 25
  end
end
