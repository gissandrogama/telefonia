defmodule Contas do
  @moduledoc """
    Modulo de contas para impressão de relatórios de assinantes `prepago` e `pospago`.
    Esse modulo possui as funções `imprimir/4` e `buscar_elementos_mes/3`.
  """

  @doc """
  Função imprime um relatório de chamadas e recargas de um assinante `prepago`. E do assinante
  `pospago` é impresso um relatório das chamadas.

  ## Parametros da função

  - mes: mes que quer gerar um relatório;
  - ano: ano para do relátorio;
  - numero: número do assinante, para ser gerado o relatório;
  - plano: tipo de plano `prepago` ou `pospago`;

  ## Informações adicionais

  - o tipo de plano é passodo nas funções `Prepago.imprimir_conta/3` e `Pospago.imprimir_conta/3`

  ## Exemplo Prepago

      iex> Assinante.cadastrar("Henry", "123", "123123", :prepago)
      iex> Recarga.nova(~U[2021-01-30 21:52:03.397639Z], 10, "123")
      iex> Prepago.fazer_chamada("123", ~U[2021-01-30 21:52:03.397639Z], 3)
      iex> Contas.imprimir(01, 2021, "123", :prepago)
      %Assinante{
      chamadas: [%Chamada{data: ~U[2021-01-30 21:52:03.397639Z], duracao: 3}],
      cpf: "123123",
      nome: "Henry",
      numero: "123",
      plano: %Prepago{
        creditos: 5.65,
        recargas: %Recarga{data: ~U[2021-01-30 23:10:52.454915Z], valor: 10}
        }
      }

  ## Exemplo Pospago

      iex> Assinante.cadastrar("Gissandro", "1234", "123123", :pospago)
      iex> Pospago.fazer_chamada("1234", ~U[2021-01-30 21:52:03.397639Z], 5)
      iex> Contas.imprimir(01, 2021, "1234", :pospago)
      %Assinante{
      chamadas: [%Chamada{data: ~U[2021-01-30 21:52:03.397639Z], duracao: 5}],
      cpf: "123123",
      nome: "Gissandro",
      numero: "1234",
      plano: %Pospago{valor: 7.0}
      }

  """
  def imprimir(mes, ano, numero, plano) do
    assinante = Assinante.buscar_assinante(numero)
    chamadas_do_mes = buscar_elementos_mes(assinante.chamadas, mes, ano)

    cond do
      plano == :prepago ->
        recargas_do_mes = buscar_elementos_mes(assinante.plano.recargas, mes, ano)
        plano = %Prepago{assinante.plano | recargas: recargas_do_mes}
        %Assinante{assinante | chamadas: chamadas_do_mes, plano: plano}

      plano == :pospago ->
        %Assinante{assinante | chamadas: chamadas_do_mes}
    end
  end

  @doc """
  Função responsavel com filtrar uma listas de recargas ou chamadas pelo `mês` e `ano`

  ## Parametros da função

  - mes: mes para buscar na lista;
  - ano: ano para buscar na lista;
  - elementos: lista de recargas ou chamadas;

  ## Informações adicionais

  -

  ## Exemplo


      iex> lista = [ %Chamada{data: ~U[2021-01-30 23:57:42.315872Z], duracao: 5}, %Chamada{data: ~U[2020-12-30 23:57:45.450832Z], duracao: 10}]
      iex> buscar_elementos_mes(lista, 01, 2021)
      [%Chamada{data: ~U[2021-01-30 23:57:42.315872Z], duracao: 5}]

  """
  def buscar_elementos_mes(elementos, mes, ano) do
    elementos
    |> Enum.filter(&(&1.data.year == ano && &1.data.month == mes))
  end
end
