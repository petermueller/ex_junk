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

  test "returns unique Strings" do
    output = Junk.junk(String)
    assert is_binary(output) == true
    assert String.printable?(output) == true
    assert output != Junk.junk(String)
  end

  test "returns Strings with an optional prefix" do
    output = Junk.junk(String, prefix: "prefix")
    assert "prefix-" <> _x = output
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
    assert "firstname-" <> _ = output
  end

  test "obeys options when returning a preset value when a preset is not defined" do
    output = Junk.junk(:firstname, byte_size: 10)
    assert String.length(output) == 20 # incidentally, this seems kind of dumb; why not 10?
  end

  test "returns a preset value when a preset is defined and used" do
    # :phone here is defined in config/test.exs
    output = Junk.junk(:phone)
    assert 10 = length(output |> Integer.digits)
  end

  test "returns a preset value when a preset function is used" do
    # :ssn here is defined in config/test.exs
    output = Junk.junk(:ssn)
    assert "123-45-6789" = output
  end

  test "returns are not unique by default" do
    output = Junk.junk(:ssn)
    assert "123-45-6789" = output
    output = Junk.junk(:ssn)
    assert "123-45-6789" = output
  end

  test "returns can be made unique" do
    # :color here is defined in config/test.exs
    output1 = Junk.junk(:color, unique: true)
    output2 = Junk.junk(:color, unique: true)
    output3 = Junk.junk(:color, unique: true)
    assert output1 != output2
    assert output2 != output3
    assert output3 != output1
  end

  def ssn do
    "123-45-6789"
  end

  def color do
    Enum.random(["red", "white", "blue"])
  end
end
