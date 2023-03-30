defmodule LabelsTest do
  use ExUnit.Case
  doctest Labels

  test "init server without labels" do
    assert {:ok, _pid} = Labels.start_link()

    assert [] = Labels.get_all("test_service")
  end

  test "Add labels" do
    assert {:ok, _pid} = Labels.start_link()
    assert :ok = Labels.add("test_service", "test_label")
    assert ["test_label"] = Labels.get_all("test_service")
  end

  test "Add labels case insensitive and avoid duplicates " do
    assert {:ok, _pid} = Labels.start_link()
    assert :ok = Labels.add("test_service", "test_label")
    assert ["test_label"] = Labels.get_all("test_service")

    assert :ok = Labels.add("test_service", "test_labeL_SECOND")
    assert ["test_label", "test_label_second"] = Labels.get_all("test_service")

    # avoid spaces
    assert :ok = Labels.add("test_service", "  test_label  ")
    assert ["test_label", "test_label_second"] = Labels.get_all("test_service")
    assert :ok = Labels.add("test_service", "  test label  ")
    assert ["test_label", "test_label_second"] = Labels.get_all("test_service")
  end
end
