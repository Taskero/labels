defmodule Labels do
  @moduledoc """
  Labels is a server to store and retrieve labels for a given key.
  It avoid duplicates and is case insensitive.
  """
  use GenServer

  @default_labels_file "./priv/imports/default_labels.csv"

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
    {:ok, table} = :dets.open_file(:labels_dets, type: :set)

    load_defaults_labels(table)

    {:ok, table}
  end

  def handle_call({:get_all, service}, _from, table) do
    case :dets.lookup(table, service) do
      [{_, labels}] -> {:reply, labels, table}
      [] -> {:reply, [], table}
    end
  end

  def handle_cast({:add, service, label}, table) do
    case :dets.lookup(table, service) do
      [{_, labels}] ->
        labels =
          [label |> clean() | labels]
          |> Enum.uniq()
          |> Enum.sort()

        :dets.insert(table, {service, labels})
        {:noreply, table}

      [] ->
        :dets.insert(table, {service, [label]})
        {:noreply, table}
    end
  end

  defp clean(label), do: label |> String.downcase() |> String.trim() |> String.replace(" ", "_")

  defp load_defaults_labels(table) do
    File.stream!(@default_labels_file)
    |> Stream.map(&String.split(&1, ","))
    |> Stream.map(fn [service, label] -> {service, label} end)
    |> Enum.to_list()
    |> Enum.group_by(fn {service, _label} -> service end)
    |> Enum.each(fn {service, labels} ->
      list =
        labels
        |> Enum.map(fn {_, label} -> label |> clean() end)

      current =
        case :dets.lookup(table, service) do
          [{_, labels}] -> labels
          [] -> []
        end

      labels = (current ++ list) |> Enum.uniq() |> Enum.sort()
      :dets.insert(table, {service, labels})
    end)
  end
end
