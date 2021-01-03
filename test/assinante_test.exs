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
      assert Assinante.cadastrar("Gissandro", "123456", "1345678900") ==
               {:ok, "Assinante Gissandro cadastrado com sucesso!"}
    end

    test "deve retorna erro dizendo que assinante ja esta cadastrado" do
      assert Assinante.cadastrar("Gissandro", "123456", "1345678900")

      assert Assinante.cadastrar("Gissandro", "123456", "1345678900") ==
               {:error, "Assinante com este numero cadastrado"}
    end
  end

  describe "Testes responsveis por bucar assinantes" do
    test "buscar pospago" do
      Assinante.cadastrar("Gissandro", "123", "123", :pospago)

      assert Assinante.buscar_assinante("123", :pospago).nome == "Gissandro"
    end

    test "buscar prepago" do
      Assinante.cadastrar("Luana", "123", "123")

      assert Assinante.buscar_assinante("123", :prepago).nome == "Luana"
    end
  end
end
