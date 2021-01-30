defmodule RecargaTest do
  use ExUnit.Case
  setup do
    File.write!("pre.txt", :erlang.term_to_binary([]))
    File.write!("pos.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm("pre.txt")
      File.rm("pos.txt")
    end)
  end

  test "Retornar a estrutura de recarga" do
    assert  %Recarga{data: nil, valor: nil} = Recarga.__struct__
  end

  test "deve realizar uma recarga" do
    Assinante.cadastrar("Henry", "123", "123123", :prepago)

    {:ok, msg} = Recarga.nova(DateTime.utc_now(), 30, "123")
    assert msg == "Recarga realizada com sucesso!"

    assinante = Assinante.buscar_assinante("123", :prepago)
    assert assinante.plano.creditos == 30
    assert Enum.count(assinante.plano.recargas) == 1

  end
end
