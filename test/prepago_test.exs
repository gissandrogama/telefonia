defmodule PrepagoTest do
  use ExUnit.Case
  doctest Prepago

  setup do
    File.write!("pre.txt", :erlang.term_to_binary([]))
    File.write!("pos.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm("pre.txt")
      File.rm("pos.txt")
    end)
  end

  describe "funções de ligação" do
    test "fazer uma ligação" do
      Assinante.cadastrar("Gissandro", "8888", "12345678900", :prepago)
      Recarga.nova(DateTime.utc_now(), 10, "8888")
      assert Prepago.fazer_chamada("8888", DateTime.utc_now(), 3) ==
               {:ok, "A chamada custou 4.35, e você tem 5.65 de creditos"}
    end

    test "fazer uma ligação longa e não tem créditos" do
      Assinante.cadastrar("Gissandro", "8888", "12345678900", :prepago)

      assert Prepago.fazer_chamada("8888", DateTime.utc_now(), 10) ==
               {:error, "Saldo insuficiente, faça uma recarga."}
    end
  end

  describe "teste para impressão de contas" do
    test "deve informar valores da conta do mês" do
      Assinante.cadastrar("Gissandro", "8888", "12345678900", :prepago)
      data_antiga = ~U[2020-12-30 00:58:59.407205Z]
      data = DateTime.utc_now()
      Recarga.nova(data, 10, "8888")
      Prepago.fazer_chamada("8888", data, 3)
      Recarga.nova(data_antiga, 10, "8888")
      Prepago.fazer_chamada("8888", data_antiga, 3)

      assinante = Assinante.buscar_assinante("8888", :prepago)

      assert Enum.count(assinante.chamadas) == 2
      assert Enum.count(assinante.plano.recargas) == 2

      assinante = Prepago.imprimir_conta(data.month, data.year, "8888")

      assert assinante.numero == "8888"
      assert Enum.count(assinante.chamadas) == 1
      assert Enum.count(assinante.plano.recargas) == 1
    end
  end
end
