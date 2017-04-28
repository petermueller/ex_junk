# Junk
Junk is a module for generating Junk data in your tests.
For when you don't care about the content, just that it has the right 'shape'.
It is inspired by Dave Brady's [rspec-junklet](https://github.com/dbrady/rspec-junklet)

## Installation

The package can be installed by adding `ex_junk` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:ex_junk, "~> 0.1.0", only: :test}]
end
```

## Example

```elixir
defmodule ExampleTest do
  import Junk 

  test "example test" do
    thing = %{
      name:    junk, # defaults to junk(String)
      some_id: junk(Integer, size: 9)
    }
    struct(SomeThing, thing)
    |> SomeThing.push

    assert SomeThing.pop == thing
  end
end
```

## Usage

```elixir
Junk.junk                          # "w8eY_L2UHZsPBBSq"
Junk.junk(String)                  # same
Junk.junk(String,  byte_size: 10)  # similar, but shorter
Junk.junk(String,  prefix: "yarp") # "yarp-w8eY_L2UHZsPBBSq..."
Junk.junk(Integer, size: 10)       # 9593685924
```


### Links
Hex - [https://hex.pm/packages/ex_junk](https://hex.pm/packages/ex_junk)
