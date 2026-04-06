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


link:     https://cdn.jsdelivr.net/gh/AndreaInfUFSM/elc117-2026a@main/assets/css/custom.css

script:   https://cdn.jsdelivr.net/gh/AndreaInfUFSM/elc117-2026a@main/assets/js/goatcounter-config.js
script:   https://gc.zgo.at/count.js

-->

<!--
nvm use v14.21.1
npx -p @liascript/devserver liascript-devserver --test --input ./README.md
liascript-devserver --input README.md --port 3001 --live

-->

[![LiaScript](https://raw.githubusercontent.com/LiaScript/LiaScript/master/badges/course.svg)](https://liascript.github.io/course/?https://raw.githubusercontent.com/AndreaInfUFSM/elc117-2026a/main/classes/11/README.md)

# Produção individual personalizada

Avaliação no primeiro bimestre:


- Prova de leitura/escrita de código (peso 5): 29/04
- Apresentação de exercícios (peso 2)
- Produção individual personalizada (peso 3): 03/05

  - ⚠️ Proposta: 12/04
  - ⚠️ Entrega: 03/05


## Objetivos e requisitos 


1. Aprofundamento em programação funcional, com aplicação e compreensão de novos recursos
2. Personalização do tema, adaptado a interesse/experiência de cada estudante
3. Teste unitário de funções 
4. Evidências de progresso individual e construção/teste incremental do código
5. Realização em etapas
6. Deploy do serviço em ambiente acessível pela web


## Tema: Backend Web com Haskell+Scotty


- Tema: desenvolver um serviço web que responda a requisições (GET, POST, etc.) usando Scotty, com ou sem banco de dados
- Conforme visto em aula, Scotty é uma biblioteca em Haskell para construção de backend web 

  - Ver mais sobre isso em [demo-scotty-codespace-2026a](https://liascript.github.io/course/?https://raw.githubusercontent.com/elc117/demo-scotty-codespace-2026a/main/README.md)

- Testes unitários:

  - A lógica do seu serviço deve ficar em funções que deverão ser **testadas independentemente** do Scotty
  - Você pode usar HUnit, ou pode simplesmente fazer um programa simples que chame as funções para testá-las, sem criação do servidor web
  

- Possibilidades de personalização:

  - Somente leitura (get): conversões, sorteios, buscas, quizzes, etc.
  - Leitura / escrita (get/post/put/delete, com persistência em banco de dados): leaderboard para game, log para quizzes/games, listas de tarefas, etc.

- Opcionais sempre bem-vindos: desde que atenda aos objetivos e requisitos do trabalho, você pode adicionar quaisquer opcionais que desejar (frontend, comparações com outras linguagens, configurações avançadas de projeto, etc.).

### Outros

- Caso você se interesse por um aprofundamento maior e tenha alguma ideia que não se encaixe em um backend web, você pode propor outro tema à professora (sujeito a validação)
- Tenha em mente que a maior parte dos objetivos e requisitos devem se manter
- Com uma boa justificativa, é possível propor um tema em outra linguagem de programação funcional


## Etapas

As etapas do trabalho são as seguintes (veja também detalhamento nas páginas seguintes):

1. Proposta de personalização do tema em um formulário próprio, com validação pela professora 
2. Criação e atualização do repositório
3. Desenvolvimento da proposta (estudo/pesquisa e construção/teste incremental do código), com commits frequentes no repositório
4. Deploy do serviço em nuvem
5. Elaboração de README.md e entrega final


### Proposta (até 12/04) e validação da personalização

- Proposta de personalização do tema neste formulário: https://forms.gle/hX38pPwsBjy5rjdN7
- Validação do tema pela professora (aguarde email)

### Repositório

- Criação de repositório: https://classroom.github.com/a/xDmvZ4it
- O repositório criado automaticamente estará vazio. Caberá a você adicionar todos os arquivos, incluindo aqueles provenientes do repositório de exemplo ([demo-scotty-codespace-2026a](https://liascript.github.io/course/?https://raw.githubusercontent.com/elc117/demo-scotty-codespace-2026a/main/README.md))
- Se você for desenvolver no Codespaces, lembre de manter no repositório a pasta oculta `.devcontainer` (contida nos repositórios de exercícios), com as configurações básicas do ambiente de desenvolvimento Haskell
- Faça commits frequentes, seja com avanços no código ou registrando comentários no README

### Desenvolvimento e testes

- Desenvolvimento da proposta: estudo/pesquisa e construção/teste incremental do código, com commits frequentes no repositório
- Lembre que é importante a criação de código de teste das funções que implementam a lógica do seu serviço (não se trata de testar se o serviço funciona pela web, mas sim de testar as funções puras que implementam a lógica)

### Deploy do serviço em nuvem

- O projeto [demo-scotty-codespace-2026a](https://liascript.github.io/course/?https://raw.githubusercontent.com/elc117/demo-scotty-codespace-2026a/main/README.md) contém instruções para deploy de um serviço web na plataforma Render



### Entrega final com README

- A entrega final deve conter:

  - Pelo menos 2 arquivos .hs: código principal e código de testes (provavelmente mais que isso, mas é o mínimo)
  - Pasta oculta .devcontainer (contida nos repositórios de exercícios), contendo as configurações básicas do ambiente de desenvolvimento Haskell
  - Arquivos Dockerfile e render.yaml para deploy no Render
  - README.md preenchido de acordo com [este template](./template_entrega_README.md)


 ⚠️ Configure o .gitignore para evitar enviar arquivos temporários, bibliotecas, etc.



## Rubricas de avaliação

<!-- data-type="none" -->
| Descrição   | Nota   |
| :--------- | :--------- |
| Trabalho com proposta claramente personalizada e validada, com lógica do serviço implementada em funções separadas do Scotty, testes presentes, evidências consistentes de desenvolvimento incremental no repositório, README completo conforme solicitado e serviço publicado com sucesso. O trabalho mostra compreensão dos recursos utilizados e alguma ampliação/adaptação em relação aos exemplos da disciplina. | 10 a 12 |
| Trabalho adequado à proposta validada, com a maior parte dos requisitos atendida: lógica principal separada do Scotty, testes presentes ainda que limitados, alguma evidência de desenvolvimento incremental, README satisfatório e serviço publicado. Mostra compreensão básica do que foi implementado.  | 7 a 9 |
| Trabalho com atendimento parcial dos requisitos: personalização limitada, separação fraca entre lógica e Scotty, testes ausentes ou muito frágeis, poucas evidências de progresso no repositório, README incompleto/superficial ou publicação não concluída adequadamente. A compreensão do que foi implementado aparece de forma limitada. | 5 a 7 |
| Trabalho não entregue, ou entregue sem elementos mínimos do proposto, ou sem evidências de progresso/compreensão compatíveis com o código apresentado, ou com indícios de desonestidade acadêmica.  | 0 a 5 |

## Regras de Conduta

- É permitido consultar qualquer material ou ferramenta que contribua para seu progresso neste trabalho, desde que as fontes sejam citadas de forma detalhada no `README.md`. Isso inclui sites, documentações, material de aula, colegas, trechos de código adaptados e ferramentas de IA.

- O uso de IA é permitido e incentivado, mas deve ficar claro que ela foi utilizada como apoio ao seu processo de estudo, desenvolvimento, teste, depuração, documentação ou refinamento, e não como substituta de sua autoria e compreensão.

- Deve ficar claro que a entrega contém partes de sua própria autoria, incluindo ideias, adaptação, integração, testes e decisões de desenvolvimento. Você deve ter bom domínio do código entregue e **ser capaz de responder perguntas** sobre ele.

- A entrega de trabalho que não é produto de seu próprio esforço/aprendizado será considerado meio **fraudulento** para lograr aprovação, enquadrado como **infração disciplinar discente grave**, conforme Art. 11, inciso XVI do [Código de Ética e Convivência Discente da UFSM](https://www.ufsm.br/pro-reitorias/proplan/codigo-de-etica-e-convivencia-discente-da-universidade-federal-de-santa-maria).


