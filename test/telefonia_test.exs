defmodule TelefoniaTest do
  use ExUnit.Case
  doctest Telefonia

  setup do
    File.write("pre.txt", :erlang.term_to_binary([]))
    File.write("pos.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm("pre.txt")
      File.rm("pos.txt")
    end)
  end

  test "deve testar estrutura" do
    assert Telefonia.cadastrar_assinante("teste", "123", "123", :prepago) ==
             {:ok, "Assinante teste cadastrado com sucesso!"}
  end

  test "listar assinantes" do
    Telefonia.cadastrar_assinante("teste", "123", "123", :prepago)

    assert Telefonia.listar_assinantes() |> Enum.count() == 1
  end

  test "listar assinantes prepago" do
    Telefonia.cadastrar_assinante("teste", "123", "123", :prepago)

    assert Telefonia.listar_assinantes_prepago() |> Enum.count() == 1
  end

  test "listar assinantes pospago" do
    Telefonia.cadastrar_assinante("teste", "123", "123", :pospago)

    assert Telefonia.listar_assinantes_pospago() |> Enum.count() == 1
  end

  test "fazer chamado pospago" do
    Telefonia.cadastrar_assinante("teste", "123", "123", :pospago)

    assert Telefonia.fazer_chamada("123", :pospago, DateTime.utc_now(), 10) ==
             {:ok, "A chamada feita com sucesso! duração: 10 minutos"}
  end

  test "fazer chamado prepago" do
    Telefonia.cadastrar_assinante("teste", "123", "123", :prepago)
    Telefonia.recarga("123", DateTime.utc_now(), 100)

    assert Telefonia.fazer_chamada("123", :prepago, DateTime.utc_now(), 10) ==
             {:ok, "A chamada custou 14.5, e você tem 85.5 de creditos"}
  end

  test "buscar numero" do
    Telefonia.cadastrar_assinante("teste", "123", "123", :prepago)
    assert Telefonia.buscar_por_numero("123")
  end

  test "imprimir contas" do
    Telefonia.cadastrar_assinante("tesaste", "123", "123654", :prepago)
    Telefonia.cadastrar_assinante("tesssate", "1234", "11232123", :pospago)

    date = DateTime.utc_now()

    assert Telefonia.imprimir_contas(date.month, date.year) == :ok
  end

  test "start" do
    assert Telefonia.start() == :ok
  end
end
