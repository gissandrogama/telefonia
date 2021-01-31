defmodule Assinante do
  @moduledoc """
    Modulo de assinante  para cadastro de tipos de assinantes como `prepago` e `pospago`

    A função mais ultilizada e a função `cadastrar/4`
  """

  defstruct nome: nil, numero: nil, cpf: nil, plano: nil, chamadas: []

  @assinantes %{:prepago => "pre.txt", :pospago => "pos.txt"}

  @doc """
  Função que lista assinantes `prepagos`, `pospagos` e também todos os assinantes

  ## Parametros da função

  - numero: numero que foi cadastrado para o assinante
  - key: a chave que é um atom com o tipo de cliente: `:prepago`, `:pospago` ou `:all`

  ## Informações adicionais

  - Caso o parametro de tipo de cliente não for passo, será listado uma lista todos os tipos de clientes

  ## Exemplo

      iex> Assinante.cadastrar("Henry", "123", "123123", :prepago)
      iex> Assinante.buscar_assinante("123", :prepago)
      %Assinante{cpf: "123123", nome: "Henry", numero: "123", plano: %Prepago{creditos: 0, recargas: []}}

      iex> Assinante.cadastrar("Gissandro", "1234", "123123", :pospago)
      iex> Assinante.buscar_assinante("1234", :pospago)
      %Assinante{cpf: "123123", nome: "Gissandro", numero: "1234", plano: %Pospago{valor: 0}}

  """
  def buscar_assinante(numero, key \\ :all), do: buscar(numero, key)

  defp buscar(numero, :prepago), do: filtro(assinantes_prepago(), numero)
  defp buscar(numero, :pospago), do: filtro(assinantes_pospago(), numero)
  defp buscar(numero, :all), do: filtro(assinantes(), numero)
  defp filtro(lista, numero), do: Enum.find(lista, &(&1.numero == numero))

  @doc """
  Função com aridade `0` que lista todos os assantes, prepagos e pospagos

  ## Exemplo


      iex> Assinante.cadastrar("Henry", "123", "123123", :prepago)
      iex> Assinante.cadastrar("Gissandro", "1234", "123123", :pospago)
      iex> Assinante.assinantes()
      [
         %Assinante{cpf: "123123", nome: "Henry", numero: "123", plano: %Prepago{creditos: 0, recargas: []}},
         %Assinante{cpf: "123123", nome: "Gissandro", numero: "1234", plano: %Pospago{valor: 0}}
      ]
  """
  def assinantes(), do: read(:prepago) ++ read(:pospago)

  @doc """
  Função com aridade `0` que lista todos os assantes prepagos

  ## Exemplo


      iex> Assinante.cadastrar("Henry", "123", "123123", :prepago)
      iex> Assinante.cadastrar("Gissandro", "1234", "123123", :pospago)
      iex> Assinante.assinantes_prepago()
      [%Assinante{cpf: "123123", nome: "Henry", numero: "123", plano: %Prepago{creditos: 0, recargas: []}}]
  """
  def assinantes_prepago(), do: read(:prepago)

  @doc """
  Função com aridade `0` que lista todos os assantes pospagos

  ## Exemplo


      iex> Assinante.cadastrar("Henry", "123", "123123", :prepago)
      iex> Assinante.cadastrar("Gissandro", "1234", "123123", :pospago)
      iex> Assinante.assinantes_pospago()
      [%Assinante{cpf: "123123", nome: "Gissandro", numero: "1234", plano: %Pospago{valor: 0}}]
  """
  def assinantes_pospago(), do: read(:pospago)

  @doc """
  Função para cadastrar assinante `prepago` ou `pospago`

  ## Parametos da função

  - nome: parametro do nome do assinante
  - numero: numero unico e caso exista pode retornar um erro
  - cpf: parametro de assinante
  - plano: opcional e caso não seja informado, o assinante será cadastrado como `prepago`

  ## informações adicionais

  - Caso o numero já exista, será retornado um erro.

  ## Exemplo


      iex> Assinante.cadastrar("Henry", "123", "123123", :prepago)
      {:ok, "Assinante Henry cadastrado com sucesso!"}


  """
  def cadastrar(nome, numero, cpf, :prepago), do: cadastrar(nome, numero, cpf, %Prepago{})
  def cadastrar(nome, numero, cpf, :pospago), do: cadastrar(nome, numero, cpf, %Pospago{})

  def cadastrar(nome, numero, cpf, plano) do
    case buscar_assinante(numero) do
      nil ->
        assinante = %__MODULE__{nome: nome, numero: numero, cpf: cpf, plano: plano}

        (read(pega_plano(assinante)) ++ [assinante])
        |> :erlang.term_to_binary()
        |> write(pega_plano(assinante))

        {:ok, "Assinante #{nome} cadastrado com sucesso!"}

      _assinante ->
        {:error, "Assinante com este numero cadastrado"}
    end
  end

  def atualizar(numero, assinante) do
    {assinante_antigo, nova_lista} = deletar_item(numero)

    case assinante.plano.__struct__ == assinante_antigo.plano.__struct__ do
      true ->
        (nova_lista ++ [assinante])
        |> :erlang.term_to_binary()
        |> write(pega_plano(assinante))

      false ->
        {:error, "Assinante não pode alterar o plano"}
    end
  end

  defp pega_plano(assinante) do
    case assinante.plano.__struct__ == Prepago do
      true -> :prepago
      false -> :pospago
    end
  end

  defp write(lista_assinantes, plano) do
    File.write!(@assinantes[plano], lista_assinantes)
  end

  def deletar(numero) do
    {assinante, nova_lista} = deletar_item(numero)

    nova_lista
    |> :erlang.term_to_binary()
    |> write(assinante.plano)

    {:ok, "Assinante #{assinante.nome} deletado!"}
  end

  def deletar_item(numero) do
    assinante = buscar_assinante(numero)

    nova_lista =
      read(pega_plano(assinante))
      |> List.delete(assinante)

    {assinante, nova_lista}
  end

  def read(plano) do
    case File.read(@assinantes[plano]) do
      {:ok, assinantes} ->
        assinantes
        |> :erlang.binary_to_term()

      {:error, :enoent} ->
        {:error, "Arquivo inválido"}
    end
  end
end
