defmodule Telefonia do
  @moduledoc """
  Modulo possui funções que fazem parse para as demais funções de outros modulos do sistema.
  """

  @doc """
  Função cria arquivos `pre.txt` e `pos.txt`, esses arquivos recebem dados dos assinantes.

  ## Exemplo

      iex> Telefonia.start()
      :ok

  """
  def start do
    File.write!("pre.txt", :erlang.term_to_binary([]))
    File.write!("pos.txt", :erlang.term_to_binary([]))
  end

  @doc """
  Função parse para `Assinante.cadastrar/4`

  """
  def cadastrar_assinante(nome, numero, cpf, plano) do
    Assinante.cadastrar(nome, numero, cpf, plano)
  end

  @doc """
  Função parse para `Assinante.assinantes/0`

  """
  def listar_assinantes, do: Assinante.assinantes()

  @doc """
  Função parse para `Assinante.assinantes_prepago/0`

  """
  def listar_assinantes_prepago, do: Assinante.assinantes_prepago()

  @doc """
  Função parse para `Assinante.assinantes_pospago/0`

  """
  def listar_assinantes_pospago, do: Assinante.assinantes_pospago()

  @doc """
  Função parse para `Prepago.fazer_chamada/3` e `Pospago.fazer_chamada/3`.

  ## Parametros da função

  - numero: numero do assinante em questão;
  - plano: tipo de plano `:prepago` ou `:pospago`;
  - data: data da chamada;
  - duracao: tempo em minutos;

  ## Informações adicionais

  - O parse é realizado conforme o tipo de plano para suas devidas funções.

  """
  def fazer_chamada(numero, plano, data, duracao) do
    cond do
      plano == :prepago -> Prepago.fazer_chamada(numero, data, duracao)
      plano == :pospago -> Pospago.fazer_chamada(numero, data, duracao)
    end
  end

  @doc """
  Função parse para ` Recarga.nova/3`.

  ## Parametros da função

  - numero: numero do assinante em questão;
  - data: data de realização da chamda;
  - valor: valor da recarga;

  """
  def recarga(numero, data, valor), do: Recarga.nova(data, valor, numero)

  @doc """
  Função parse para ` Assinante.buscar_assinante/2`.

  ## Parametros da função

  - numero: numero do assinante em questão;
  - plano: tipo de plano do assinante `:prepago` ou `:pospago`;

  ## Informações adicionais

  - caso o tipo de plano não for passado, vai ser listado todos os tipos de assinantes;

  """
  def buscar_por_numero(numero, plano \\ :all), do: Assinante.buscar_assinante(numero, plano)

  @doc """
  Funação imprime um relatório de todos os assinantes do sistema. A função faz um parse para as funções
  `Prepago.imprimir_conta/3` e `Pospago.imprimir_conta/3`. Pega os dados filtrados por mês e ano e imprime na tela.

  ## Parametros da função

  - mes: parametro que será usado para filtrar os dados por mês;
  - ano: parametro que será usado para filtrar os dados por ano;

  """
  def imprimir_contas(mes, ano) do
    Assinante.assinantes_prepago()
    |> Enum.each(fn assinante ->
      assinante = Prepago.imprimir_conta(mes, ano, assinante.numero)
      IO.puts("Conta Prepaga do Assinante: #{assinante.nome}")
      IO.puts("Numero: #{assinante.numero}")
      IO.puts("Chamadas: ")
      IO.inspect(assinante.chamadas)
      IO.puts("Recargas: ")
      IO.inspect(assinante.plano.recargas)
      IO.puts("Total de Chamandas: #{Enum.count(assinante.chamadas)}")
      IO.puts("Total de Recargas: #{Enum.count(assinante.plano.recargas)}")
      IO.puts("================================================================")
    end)

    Assinante.assinantes_pospago()
    |> Enum.each(fn assinante ->
      assinante = Pospago.imprimir_conta(mes, ano, assinante.numero)
      IO.puts("Conta do tipo Pospago do Assinante: #{assinante.nome}")
      IO.puts("Numero: #{assinante.numero}")
      IO.puts("Chamadas: ")
      IO.inspect(assinante.chamadas)
      IO.puts("Total de Chamandas: #{Enum.count(assinante.chamadas)}")
      IO.puts("Valor da fatura: #{assinante.plano.valor}")
      IO.puts("================================================================")
    end)
  end
end
