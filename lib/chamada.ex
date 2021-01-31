defmodule Chamada do
  @moduledoc """
    Esse modulo contem função que atualiza lista de chamadas de um assinante, tanto prepago como pospago.

    A função ultilizada é a `registar/3`
  """
  defstruct data: nil, duracao: nil

  @doc """
  A função atualiza a lista de chamada de um assinante e para a função `Assinante.atualizar`,
  um assinante com a lista atualizada.

  ## Parametros da função

  - assinante: uma estrutura %Assinante{};
  - data: data que a chamada foi realizada;
  - duracao: duracao das chamadas em minutos;

  ## Informações adicionais


  ## Exemplo

      iex> Assinante.cadastrar("Henry", "123", "123123", :pospago)
      iex> assinante = Assinante.buscar_assinante("123", :pospago)
      iex> Chamada.registrar(assinante, DateTime.utc_now(), 3)
      :ok

  """
  def registrar(assinante, data, duracao) do
    assinante_atualizado = %Assinante{
      assinante
      | chamadas: assinante.chamadas ++ [%__MODULE__{data: data, duracao: duracao}]
    }

    Assinante.atualizar(assinante.numero, assinante_atualizado)
  end
end
