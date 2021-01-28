defmodule AssinanteTest do
  use ExUnit.Case
  doctest Assinante

  setup do
    File.write!("pre.txt", :erlang.term_to_binary([]))
    File.write!("pos.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm("pre.txt")
      File.rm("pos.txt")
    end)
  end

  describe "Testes responsaveis por cadastro de assinantes" do
    test "Retornar a estrutura de assinante" do
      assert %Assinante{} = %Assinante{cpf: nil, nome: nil, numero: nil, plano: nil}
    end

    test "criar uma conta prepago" do
      assert Assinante.cadastrar("Gissandro", "123456", "1345678900", :prepago) ==
               {:ok, "Assinante Gissandro cadastrado com sucesso!"}
    end

    test "deve retorna erro dizendo que assinante ja esta cadastrado" do
      assert Assinante.cadastrar("Gissandro", "123456", "1345678900", :prepago)

      assert Assinante.cadastrar("Gissandro", "123456", "1345678900", :prepago) ==
               {:error, "Assinante com este numero cadastrado"}
    end
  end

  describe "Testes responsveis por bucar assinantes" do
    test "buscar pospago" do
      Assinante.cadastrar("Gissandro", "123", "123", :pospago)
      assert Assinante.buscar_assinante("123", :pospago).nome == "Gissandro"
      assert Assinante.buscar_assinante("123", :pospago).plano.__struct__ == Pospago
    end

    test "buscar prepago" do
      Assinante.cadastrar("Luana", "123", "123", :prepago)
      assert Assinante.buscar_assinante("123", :prepago).nome == "Luana"
    end
  end

  describe "deletar" do
    test "deve deltar o assinante" do
      Assinante.cadastrar("Luana", "123", "123", :prepago)
      Assinante.cadastrar("Henry", "1234", "321", :prepago)
      assert Assinante.deletar("123") == {:ok, "Assinante Luana deletado!"}
    end
  end
end
