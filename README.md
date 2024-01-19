### Instalação

Este projeto conta com Docker, e, estando no diretório do projeto, pode ser configurado com o seguinte comando:

```
docker-compose build
```

Caso prefira utilizar o Ruby nativo da máquina, também no diretório do projeto utilize o seguinte comando:

```
bundle install
```

### Como utilizar

A aplicação é iniciada pelo console através do arquivo `app.rb` com os seguinte comandos

Com Ruby local:

```
ruby app.rb
```

Ou utilizando Docker:

```
docker-compose run app
```

As operações são inseridas em texto, no formato JSON, diretamente no terminal, e obrigatoriamente em *single line*. Ex:

Abastecimento:
```json
{ "caixa":{ "caixaDisponivel":true, "notas":{ "notasDez":100, "notasVinte":50, "notasCinquenta":10, "notasCem":30 } } }
```

Saque:
```json
{ "saque":{ "valor":600, "horario":"2019-02-13T11:01:01.000Z" } }
```
