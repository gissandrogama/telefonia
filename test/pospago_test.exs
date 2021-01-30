defmodule PospagoTest do
  use ExUnit.Case
  doctest Pospago

  setup do
    File.write!("pre.txt", :erlang.term_to_binary([]))
    File.write!("pos.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm("pre.txt")
      File.rm("pos.txt")
    end)
  end

  test "fazer uma chamada" do
    Assinante.cadastrar("Gissandro", "8888", "12345678900", :pospago)
    assert Pospago.fazer_chamada("8888", DateTime.utc_now(), 5) ==
             {:ok, "A chamada feita com sucesso! duração: 5 minutos" }
  end


  test "deve informar valores da conta do mês" do
    Assinante.cadastrar("Gissandro", "8888", "12345678900", :pospago)
    data_antiga = ~U[2020-12-30 00:58:59.407205Z]
    data = DateTime.utc_now()
    Pospago.fazer_chamada("8888", data, 3)
    Pospago.fazer_chamada("8888", data, 3)
    Pospago.fazer_chamada("8888", data, 3)
    Pospago.fazer_chamada("8888", data_antiga, 3)

    assinante = Assinante.buscar_assinante("8888", :pospago)
    assert Enum.count(assinante.chamadas) == 4

    assinante = Pospago.imprimir_conta(data.month, data.year, "8888")
    assert assinante.numero == "8888"
    assert Enum.count(assinante.chamadas) == 3
    assert assinante.plano.valor == 12.599999999999998
  end
end
