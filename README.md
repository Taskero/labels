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

## View all content

In order to view all the contents, pass the `dets` to a public `ets`

```elixir
Labels.start_link
temporary_ets = :ets.new(:temporary_ets, [:public])
:dets.to_ets(:labels_dets, temporary_ets)
:ets.info(temporary_ets) # memory
:ets.tab2list(temporary_ets)
[ {"taskero", ["a", "b", .. , "z"]} ]
# or view with observer
:observer.start

```

## Installation

```elixir
def deps do
  [
     {:labels, "~> 0.1.0", git: "git@github.com:Taskero/labels.git"},
  ]
end

# Add to Supervised
defmodule Application do
  def start(_type, _args) do
    children = [{Labels, [default_labels_file: Application.get_env(:labels, :default_labels_file)]}]
    opts = [strategy: :one_for_one, name: Taskero.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

# Optional if you have a default list of labels
config :labels,
  service: "my_app",
  default_labels_file: "#{Path.expand("../deps", __DIR__)}/labels/priv/imports/default_labels.csv"

```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/labels>.
