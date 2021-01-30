defmodule ChamadaTest do
  use ExUnit.Case

  test "Retornar a estrutura de chamada" do
    assert Chamada.__struct__.data == nil
  end
end
