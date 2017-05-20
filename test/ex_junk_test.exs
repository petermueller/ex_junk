defmodule JunkTest do
  use ExUnit.Case
  doctest Junk

  test "no parameters whatsoever returns random string" do
    output = Junk.junk
    assert is_binary(output) == true
    assert String.printable?(output) == true
    assert output != Junk.junk(String)
  end

  test "no option defaults .junk to String" do
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

  test "unnecessary options are ignored" do
    string = Junk.junk(String, size: 10)
    integer = Junk.junk(Integer, byte_size: "asdf")
    assert is_binary(string) == true
    assert integer |> is_integer == true
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

  test "returns just the random string if no prefix is defined" do
    output = Junk.junk(String)
    assert String.at(output, 0) != "-"
  end

  test "returns unique Integers" do
    assert Junk.junk(Integer) |> is_integer == true
    assert Junk.junk(Integer) != Junk.junk(Integer)
  end

  test "returns Integers to optional unit size" do
    digits = Junk.junk(Integer, size: 25) |> Integer.digits
    assert Kernel.length(digits) == 25
  end

  test "returns a value when a function is used" do
    foo = Junk.junk(fn() -> "foo" end)
    assert "foo" = foo
  end

  test "returns a value when a function is used with a parameter" do
    f = fn(x) -> "#{x}-result" end
    output = Junk.junk(f, parameters: [1])
    assert "1-result" = output
    output2 = Junk.junk(f, parameters: [2])
    assert "2-result" = output2
  end

  test "returns a preset value when a preset is not defined" do
    output = Junk.junk(:firstname)
    assert String.starts_with?(output, "firstname")
    assert String.length(output) > String.length("firstname-")
  end

  test "returns a preset value when a preset is defined and used" do
    output = Junk.junk(:phone)
    assert 10 = length(output |> Integer.digits)
  end

  test "returns a preset value when a preset function is used" do
    output = Junk.junk(:ssn)
    assert "123-45-6789" = output
  end

  test ":npi returns a short NPI" do
    digits = Junk.junk(:npi) |> Integer.digits
    assert Kernel.length(digits) == 10
    assert Enum.member?([1,2], List.first(digits))
  end

  test ":long_npi returns a long NPI" do
    digits = Junk.junk(:long_npi) |> Integer.digits
    assert Kernel.length(digits) == 15
    first_6 = digits |> Enum.take(6) |> Integer.undigits
    assert Enum.member?([808401,808402], first_6)
  end

  test "luhn returns a luhn'd number" do
    assert Junk.luhn(80840268496713) == 808402684967138
  end

  def ssn do
    "123-45-6789"
  end
end
