defmodule Recarga do
  @moduledoc """
    Esse modulo contem função que trata de alterar os valores do do plano `prepago`.
    Os valores são os `creditos` e `recargas`.

    A função ultilizada é a `nova/3`
  """
  defstruct data: nil, valor: nil

  @doc """
  Função que trata da atualização de valores de creditos e do histórico de recargas de um assinante `prepago`.

  ## Parametros da função

  - data: a data que está sendo realizado a recarga;
  - valor: o valor da recarga;
  - numero: o numero que será feito a recarga

  ## Informações adicionais

  - A função faz uma busca de assinante pelo numero. Ao encontrar o numero é feito uma atualização
  na estrutura `plano` do assinante. A estrutura é composta de `creditos` e uma lista `recargas`.
  - creditos: é o somatório dos valores da lista `recargas`;
  - recargas: é uma lista de com os as datas e valores de cada recarga;

  ## Exemplo

      iex> Assinante.cadastrar("Henry", "123", "123123", :prepago)
      iex> Recarga.nova(DateTime.utc_now(), 10, "123")
      {:ok, "Recarga realizada com sucesso!"}

  """
  def nova(data, valor, numero) do
    assinante = Assinante.buscar_assinante(numero, :prepago)
    plano = assinante.plano

    plano = %Prepago{
      plano
      | creditos: plano.creditos + valor,
        recargas: plano.recargas ++ [%__MODULE__{data: data, valor: valor}]
    }

    assinante = %Assinante{assinante | plano: plano}
    Assinante.atualizar(numero, assinante)

    {:ok, "Recarga realizada com sucesso!"}
  end
end
