# Labels

Simple server to store labels by service
It use `dets` persist

## Usage

```elixir
Labels.start_link
{:ok, #PID<0.299.0>}

Labels.get_all(:my_cool_service)
[]
Labels.add(:my_cool_service, "bar")
:ok
Labels.add(:my_cool_service, "foo")
:ok
Labels.get_all(:my_cool_service)
["bar", "foo"]
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `labels` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:labels, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/labels>.

