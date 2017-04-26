# Junk
Junk is a module for generating Junk data in your tests.
For when you don't care about the content, just that it has the right 'shape'.
It is inspired by Dave Brady's [rspec-junklet](https://github.com/dbrady/rspec-junklet)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ex_junk` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:ex_junk, "~> 0.1.0", only: :test}]
end
```

## Usage

```elixir
defmodule ExampleTest do
  import Junk 

  test "example test" do
    thing = %SomeThing{
      name:    junk, # defaults to junk(String)
      some_id: junk(Integer, length: 9)
    }
    struct(SomeThing, thing)
    |> SomeThing.push

    assert SomeThing.pop == thing
  end
end
```


