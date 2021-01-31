defmodule Prepago do
  @moduledoc """
    Esse modulo contem funções que tratam de uma chamada de um assinante `prepago` e impressão de conta.

    A função ultilizada é a `fazer_chamada/3` e `imprimir_conta/3`.
  """
  defstruct creditos: 0, recargas: []

  @preco_minuto 1.45

  @doc """
  Função executa uma chamada, atualiza os valores de `creditos` do assinante conforme o custo da chamda e
  também passa essas informações para serem registrar em um histórico de chamadas.
  O custo da chamada é o resultado do produto valor por minuto e duração. valor por minuto está armazenado na variavel
  de modulo `@preco_minuto` e duração é passado como argumento da função.

  ## Parametros da função

  - numero: numero quer será executado a chamada;
  - data: data da chamada;
  - duracao: duração em minutos da chamada;

  ## Informações adicionais

  - Caso o assinante não tenha crédito suficiente é um erro informando que não tem saldo para realizar chamadas.


  ## Exemplo

      iex> Assinante.cadastrar("Henry", "123", "123123", :prepago)
      iex> Recarga.nova(DateTime.utc_now(), 10, "123")
      iex> Prepago.fazer_chamada("123", DateTime.utc_now(), 3)
      {:ok, "A chamada custou 4.35, e você tem 5.65 de creditos"}

  """
  def fazer_chamada(numero, data, duracao) do
    assinante = Assinante.buscar_assinante(numero, :prepago)
    custo = @preco_minuto * duracao

    cond do
      custo <= assinante.plano.creditos ->
        plano = assinante.plano
        plano = %__MODULE__{plano | creditos: plano.creditos - custo}

        %Assinante{assinante | plano: plano}
        |> Chamada.registrar(data, duracao)

        {:ok, "A chamada custou #{custo}, e você tem #{plano.creditos} de creditos"}

      true ->
        {:error, "Saldo insuficiente, faça uma recarga."}
    end
  end

  @doc """
  Função é um parser para `Contas.imprimir/4`

  ## Parametros da função

  - mes: mês que deseja gerar o relatório de recargas e chamadas de um assinante `prepago`;
  - ano: ano para ser gerado o relatório;
  - numero: numero do assinante em questão;

  ## Informações adicionais

  -

  ## Exemplo

      iex> Assinante.cadastrar("Henry", "123", "123123", :prepago)
      iex> Recarga.nova(~U[2021-01-30 21:52:03.397639Z], 10, "123")
      iex> Prepago.fazer_chamada("123", ~U[2021-01-30 21:52:03.397639Z], 3)
      iex> Prepago.imprimir_conta(01, 2021, "123")
      %Assinante{
      chamadas: [%Chamada{data: ~U[2021-01-30 21:52:03.397639Z], duracao: 3}],
      cpf: "123123",
      nome: "Henry",
      numero: "123",
      plano: %Prepago{
        creditos: 5.65,
        recargas: [%Recarga{data: ~U[2021-01-30 21:52:03.397639Z], valor: 10}]
        }
      }

  """
  def imprimir_conta(mes, ano, numero) do
    Contas.imprimir(mes, ano, numero, :prepago)
  end
end
