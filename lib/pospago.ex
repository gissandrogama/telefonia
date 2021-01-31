defmodule Pospago do
  @moduledoc """
    Esse modulo contem funções que tratam de uma chamada de um assinante `pospago` e impressão de conta.

    A função ultilizada é a `fazer_chamada/3` e `imprimir_conta/3`.
  """
  defstruct valor: 0

  @custo_minuto 1.40

  @doc """
  Função é parse para a função `Chamada.registrar()` que atualiza a lista de chamada de um assinante.

  ## Parametros da função

  - numero: numero quer será executado a chamada;
  - data: data da chamada;
  - duracao: duração em minutos da chamada;

  ## Informações adicionais

  -


  ## Exemplo

      iex> Assinante.cadastrar("Henry", "123", "123123", :pospago)
      iex> Pospago.fazer_chamada("123", DateTime.utc_now(), 3)
      {:ok, "A chamada feita com sucesso! duração: 3 minutos"}

  """
  def fazer_chamada(numero, data, duracao) do
    Assinante.buscar_assinante(numero, :pospago)
    |> Chamada.registrar(data, duracao)

    {:ok, "A chamada feita com sucesso! duração: #{duracao} minutos"}
  end

  @doc """
  Função faz um parser para `Contas.imprimir/4` que retornar um assinante com uma
  lista de chamadas atualizadas referente ao mes e ano, que foi passando como paramentro nessa função.
  Após receber o assinante com a lista filtrada. A função faz um somatorio das durações das chamadas
  com o valor de chamada por minuto que é de `1.40` que está armazenando na variavel de modulo `@custo_minuto`.
  E atualiza a estrutura plano do assinante com o  valor total.

  ## Parametros da função

  - mes: mês que deseja gerar o relatório de recargas e chamadas de um assinante `prepago`;
  - ano: ano para ser gerado o relatório;
  - numero: numero do assinante em questão;

  ## Informações adicionais

  -

  ## Exemplo

      iex> Assinante.cadastrar("Henry", "123", "123123", :pospago)
      iex> Pospago.fazer_chamada("123", ~U[2021-01-30 21:52:03.397639Z], 3)
      iex> Pospago.imprimir_conta(01, 2021, "123")
      %Assinante{
      chamadas: [%Chamada{data: ~U[2021-01-30 21:52:03.397639Z], duracao: 3}],
      cpf: "123123",
      nome: "Henry",
      numero: "123",
      plano: %Pospago{valor: 4.199999999999999}
      }

  """
  def imprimir_conta(mes, ano, numero) do
    assinante = Contas.imprimir(mes, ano, numero, :pospago)

    valor_total =
      assinante.chamadas
      |> Enum.map(&(&1.duracao * @custo_minuto))
      |> Enum.sum()

    %Assinante{assinante | plano: %__MODULE__{valor: valor_total}}
  end
end
