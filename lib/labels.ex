defmodule Labels do
  @moduledoc """
  Labels is a server to store and retrieve labels for a given key.
  It avoid duplicates and is case insensitive.
  """
  use GenServer

  # Client

  @doc """
  Starts the server.

  ## Examples
    {:ok, pid} = Labels.start_link()
    {:ok, #PID<0.173.0>}
  """
  @spec start_link(keyword()) :: {:ok, pid}
  def start_link(args \\ []), do: GenServer.start_link(__MODULE__, args, name: __MODULE__)

  @doc """
  Returns the list of unique labels by request service.
  """
  def get_all(service), do: GenServer.call(__MODULE__, {:get_all, service})

  @doc """
  Add a new one
  """
  def add(service, label), do: GenServer.cast(__MODULE__, {:add, service, label})

  # Server

  def init(_args) do
    table = :ets.new(:labels, [:ordered_set, :public])

    # TODO: load from disk

    {:ok, table}
  end

  def handle_call({:get_all, service}, _from, table) do
    case :ets.lookup(table, service) do
      [{_, labels}] -> {:reply, labels, table}
      [] -> {:reply, [], table}
    end
  end

  def handle_cast({:add, service, label}, table) do
    case :ets.lookup(table, service) do
      [{_, labels}] ->
        :ets.insert(table, {service, [label |> clean() | labels] |> Enum.uniq() |> Enum.sort()})
        {:noreply, table}

      [] ->
        :ets.insert(table, {service, [label]})
        {:noreply, table}
    end
  end

  defp clean(label), do: label |> String.downcase() |> String.trim() |> String.replace(" ", "_")
end
