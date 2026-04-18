<!--
author:   Andrea Charão

email:    andrea@inf.ufsm.br

version:  0.0.1

language: PT-BR

narrator: Brazilian Portuguese Female

comment:  Material de apoio para a disciplina
          ELC117 - Paradigmas de Programação
          da Universidade Federal de Santa Maria

translation: English  translations/English.md

link:     https://cdn.jsdelivr.net/chartist.js/latest/chartist.min.css

script:   https://cdn.jsdelivr.net/chartist.js/latest/chartist.min.js

link:     https://cdn.jsdelivr.net/gh/AndreaInfUFSM/elc117-2026a@main/assets/css/custom.css

script:   https://cdn.jsdelivr.net/gh/AndreaInfUFSM/elc117-2026a@main/assets/js/goatcounter-config.js
script:   https://gc.zgo.at/count.js

-->


<!--
nvm use v14.21.1
liascript-devserver --input README.md --port 3001 --live
npx -p @liascript/devserver liascript-devserver --test --input ./README.md
https://liascript.github.io/course/?https://raw.githubusercontent.com/AndreaInfUFSM/elc117-2026a/master/classes/12/README.md
-->

[![LiaScript](https://raw.githubusercontent.com/LiaScript/LiaScript/master/badges/course.svg)](https://liascript.github.io/course/?https://raw.githubusercontent.com/AndreaInfUFSM/elc117-2026a/main/classes/12/README.md)


# Programação Funcional em Haskell

> Exercícios, muitos exercícios!

<script>
  window.goatcounter.count({
    path: "/elc117-2026a/classes/12",
    title: "/elc117-2026a/classes/12"
  })
</script>

## Com correção automática



### Questão 1

<h4>Assunto: estrutura mínima de um serviço Scotty</h4>

Qual é o papel de `scotty 3000` no exemplo `hello`?

- [( )] Define uma função pura que recebe uma string e retorna outra string  
- [(X)] Inicia um serviço web escutando requisições na porta 3000  
- [( )] Converte automaticamente `String` em JSON  
- [( )] Faz o deploy automático do serviço
******************************

**Explicação:** o exemplo `hello` mostra que o serviço web é uma ação de `IO` que responde requisições na porta 3000.

******************************

``` haskell
{-# LANGUAGE OverloadedStrings #-}
import Web.Scotty
import Network.Wai.Middleware.RequestLogger (logStdoutDev)

main :: IO ()
main = scotty 3000 $ do
  middleware logStdoutDev

  -- Define your routes and handlers here
  get "/hello" $ do
    text "Hello, Haskell Web Service!"

```


### Questão 2

<h4>Assunto: rotas do serviço web</h4>

No trecho abaixo, o que a rota faz?

```haskell
get "/users" $ do
  users <- liftIO $ query_ conn "SELECT id, name, email FROM users" :: ActionM [User]
  json users
```

- [( )] Insere um usuário no banco de dados
- [( )] Autentica o usuário com email e senha
- [(X)] Lista usuários existentes no banco de dados
- [( )] Nenhuma das respostas anteriores
******************************

**Explicação:** `get "/users"` executa um SELECT que retorna os usuários existentes no banco de dados

******************************





### Questão 3

<h4>Assunto: OverloadedStrings</h4>


A diretiva abaixo está presente em todos os exemplos. Para que ela serve?

```haskell
{-# LANGUAGE OverloadedStrings #-}
```

- [( )] Para permitir múltiplas requisições ao servidor
- [( )] Para habilitar acesso ao banco SQLite  
- [(X)] Para facilitar o uso de diferentes representações de strings, como `Text`  
- [( )] Para que o Scotty reconheça parâmetros na URL
******************************

**Explicação:** essa diretiva instrui o compilador a considerar texto literal (por exemplo "Hello") como sendo compatível com diferentes tipos: String, Text, ByteString. Sem a diretiva, seria necessário usar funções para conversão.

******************************



### Questão 4

<h4>Assunto: Middleware</h4>

Qual é a função de `middleware logStdoutDev` nos exemplos?

- [( )] Criar novas rotas automaticamente  
- [(X)] Registrar logs das requisições durante o desenvolvimento  
- [( )] Converter respostas para JSON  
- [( )] Permitir acesso ao banco de dados
******************************

**Explicação:** middleware é uma camada de software que fica "no meio" do caminho entre a requisição (o pedido do usuário) e a resposta final do servidor. Esse middleware em particular é executado antes/depois das requisições para registrar logs no terminal, para facilitar o monitoramento do servidor.

******************************


### Questão 5



<h4>Assunto: Parâmetros em rotas</h4>

Considere o exemplo:

```haskell
get "/hello/:name" $ do
  name <- pathParam "name"
  text (T.pack (makeGreeting name))
```

O que `pathParam "name"` faz?

- [( )] Cria uma nova rota chamada `name`  
- [( )] Procura um parâmetro em formulário HTML  
- [(X)] Obtém da URL o valor associado ao parâmetro `:name`  
- [( )] Converte `name` em JSON
******************************

**Explicação:** o valor passado na URL é extraído e enviado para uma função pura.

******************************



### Questão 6

<h4>Assunto: Função pura</h4>


No exemplo `hello/name`, qual é a função pura?


- [(X)] `makeGreeting`  
- [( )] `pathParam`  
- [( )] `scotty`  
- [( )] `middleware`
******************************

**Explicação:** ela recebe um valor e produz outro sem interagir com o mundo externo, sem efeito colateral.

******************************



``` haskell
{-# LANGUAGE OverloadedStrings #-}
import Web.Scotty
import Network.Wai.Middleware.RequestLogger (logStdoutDev)
import qualified Data.Text.Lazy as T

makeGreeting :: String -> String
makeGreeting name = "Hello, " ++ name ++ "!"

main :: IO ()
main = scotty 3000 $ do
  middleware logStdoutDev

  get "/hello/:name" $ do
    name <- pathParam "name"
    text (T.pack (makeGreeting name))
```


### Questão 7

<h4>Assunto: IO e respostas dinâmicas</h4>



Por que `getRandomAdvice` tem tipo `IO Text`?

- [( )] Porque toda função em Haskell faz `IO`  
- [( )] Porque não é possível fazer `IO` de `String` em Haskell
- [(X)] Porque usa `randomRIO`, que envolve interação com o mundo externo  
- [( )] Porque Scotty exige que toda função auxiliar tenha tipo `IO`
******************************

**Explicação:** funções que interagem com o "mundo externo" em Haskell têm tipo `IO`.

******************************



``` haskell

getRandomAdvice :: IO Text
getRandomAdvice = do
    index <- randomRIO (0, length advices - 1)
    return $ advices !! index
```


### Questão 8

<h4>Assunto: função liftIO</h4>


No trecho abaixo do exemplo `random advice`, por que aparece `liftIO`?


- [( )] Para transformar uma rota GET em POST  
- [( )] Para converter `Text` em `String`  
- [(X)] Para trazer para dentro do Scotty o resultado de uma ação em `IO`  
- [( )] Para registrar logs do servidor
******************************

**Explicação:** `liftIO` integra ao Scotty uma ação que depende do mundo externo.

******************************

``` haskell
main :: IO ()
main = scotty 3000 $ do
    middleware logStdoutDev
    get "/advice" $ do
        randomAdvice <- liftIO getRandomAdvice   
        text randomAdvice
```


### Questão 9

<h4>Assunto: JSON </h4>


No exemplo que retorna um conselho em formato JSON, por que o código usa `pack` e `unpack`?

- [( )] Para criptografar a resposta  
- [(X)] Para converter entre `Text` e `String` ao formatar JSON manualmente  
- [( )] Para acessar parâmetros da rota  
- [( )] Para ordenar a lista de conselhos
******************************

**Explicação:** foram usadas essas funções para demonstrar que é possível formatar JSON manualmente, mas para JSON mais complexo é melhor usar biblioteca apropriada.

******************************

``` haskell
getRandomAdvice :: IO Text
getRandomAdvice = do
    index <- randomRIO (0, length advices - 1)
    let advice = advices !! index
        responseString = "{\"advice\": \"" ++ unpack advice ++ "\"}"
        responseText = pack responseString
    return responseText
```



### Questão 10

<h4>Assunto: cabeçalhos HTTP </h4>

Para que serve este trecho?

```haskell
setHeader "Content-Type" "application/json"
```

- [( )] Para definir a porta do servidor  
- [( )] Para enviar parâmetros ao cliente  
- [(X)] Para informar que a resposta está em formato JSON  
- [( )] Para ativar o middleware de log
******************************

**Explicação:** esse cabeçalho controla metadados importantes da resposta em APIs.

******************************



### Questão 11

<h4>Assunto: função de alta ordem</h4>

No serviço de POIs (Pontos de Interesse), a rota `/near/:lat/:lon` retorna somente pontos próximos, dentro de uma distância. Qual função de alta ordem ajuda nessa operação?

- [( )] `foldr`  
- [(X)] `filter`  
- [( )] `zipWith`  
- [( )] `map`
******************************

**Explicação:** o exemplo usa `filter isNear poiList` para selecionar os pontos de interesse próximos.

******************************


### Questão 12

<h4>Assunto: boas práticas</h4>
 

Quando o código de uma rota começa a ficar longo, o que é recomendável?

- [( )] Mover tudo para comentários  
- [(X)] Separar a lógica em funções puras e deixar a rota mais enxuta  
- [( )] Substituir Scotty por outro framework  
- [( )] Colocar tudo dentro de `main`
******************************

**Explicação:** a rota deve ficar mais focada na integração com a web.

******************************





### Questão 13

Verdadeiro ou falso: `makeGreeting` é uma boa candidata a teste unitário independente do Scotty.

- [(X)] Verdadeiro  
- [( )] Falso
******************************

**Explicação:** esse tipo de separação entre lógica e camada web ajuda nos testes.

******************************



### Questão 14

Verdadeiro ou falso: `randomRIO` é um exemplo de operação puramente determinística, sem efeitos colaterais.

- [( )] Verdadeiro  
- [(X)] Falso
******************************

**Explicação:** essa função de geração de aleatoriedade, em Haskell, é tratada como algo que depende do mundo externo ou do estado do gerador aleatório, logo não é uma função pura comum.

******************************







## Sem correção automática


### Questão 1: list comprehension

Qual o resultado de `[x * 2 | x <- [1..5], x > 3]` ?

- [[a]] [2,4,6,8,10]
- [[b]] [8,10]



### Questão 2: map 

Qual o resultado de `map (\n -> (n, n+1)) $ take 2 [1..]` ?

- [[a]] [1,2,3,4]
- [[b]] [(1,2),(2,3)]

### Questão 3: filter

Qual o resultado de `filter even $ take 5 [1..]` ?

- [[a]] [1,3,5]
- [[b]] [2,4]

### Questão 4: zipWith 

Qual o resultado de `zipWith (\x y -> if x > y then x else y) [1,5,3] [2,4]`?

- [[a]] [2,5]
- [[b]] [5,3]

### Questão 5: foldr1

Qual o resultado de `foldl1 (++) ["ha","sk","ell"]` ?

- [[a]] "haskell"
- [[b]] ["ell","sk","ha"]

### Questão 6: list comprehension

Qual o resultado de `[(x,y) | x <- [1..3], y <- [1..4], x + y == 4]` ?

- [[a]] [(1,3),(2,2),(3,1)]
- [[b]] [(1,3),(3,1)]






