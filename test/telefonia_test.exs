defmodule TelefoniaTest do
  use ExUnit.Case
  doctest Telefonia

  @tag :pending
  test "greets the world" do
    assert Telefonia.hello() == :world
  end
end
