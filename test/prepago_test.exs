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
end
