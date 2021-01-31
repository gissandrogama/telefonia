# Telefonia

**TODO: projeto executado no curso de elixir e phoenix da Elxpro**
Esse projeto foi construindo no modulo 1 do curso `ElxPro`. Projeto que ensina muito de elixir,
manipulação de arquivos, estruturas de dados, criar documentação, criar testes, ultilizar TDD, refatoração de código, ultilizar Enum's de forma eficiente e muitas outras coisas.

# Informacoes Tecnicas

- ecosistema elixir

## Iniciando localmente

**1.** Clone o projeto:

 * ssh
```sh
$ git git@github.com:gissandrogama/telefonia.git
```

 * https
```sh
$ git clone https://github.com/gissandrogama/telefonia.git
```

**2.** Acesse a pasta do projeto:

```sh
$ cd telefonia
```

**3.** Instale as dependências:

```sh
$ mix deps.get
```

**4.** criar e migrar o banco de dados, e inserir dados do db.json:

```sh
$ iex -S mix
```

# Gerar documentação da aplicação

Para gerar a documentação da aplicação só excutar o comando:
```sh
$ mix docs
```
A documentação ira guiar você de forma certa para utilizar o sistema.

# Breve tutorial

## Gerar arquivos para armazenar os dados
```Elixir
    iex> Telefonia.start
```

## Cadastrar um assinante
```Elixir
    iex> Telefonia.cadastrar_assinante "Gissandro", "123", "123456", :prepago
    iex> Telefonia.cadastrar_assinante "Henry", "1234", "123456", :pospago
```

## Listar assinantes
```Elixir
    iex> Telefonia.listar_assinantes()
```

## Fazer uma recarga
```Elixir
    iex> Telefonia.recarga("123", DateTime.utc_now, 20)
```

## Fazer uma chamada
```Elixir
    iex> Telefonia.fazer_chamada("123", :prepago, DateTime.utc_now, 3)
```

## Imprimir um relatório dos assinantes
```Elixir
    iex> Telefonia.imprimir_contas(01, 2021)
```


