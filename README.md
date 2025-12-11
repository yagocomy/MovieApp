# 🎬 MovieApp

Aplicativo iOS desenvolvido em **Swift**, utilizando **UIKit + View Code + MVVM**, com consumo da API do **TheMovieDB (TMDb)**.  
O projeto faz parte de um processo seletivo e demonstra boas práticas de arquitetura, organização de código, testes, componentes reutilizáveis e integração com API REST.

---

## 📸 Screenshots

<img width="200" height="500" src="https://github.com/user-attachments/assets/843c247c-14f9-4e4d-8881-3e495d5a819c" />
<img width="200" height="500" src="https://github.com/user-attachments/assets/91bd0aa5-5b6b-466d-8d80-60769e027e03" />
<img width="200" height="500" src="https://github.com/user-attachments/assets/9b4c56f8-3614-4a33-a7fb-e4fd99eea4a5" />

---

## 📎 Repositório

👉 https://github.com/yagocomy/MovieApp

---

## 🚀 Sobre o Projeto

O MovieApp exibe uma lista de filmes populares, permite buscar filmes, visualizar detalhes, favoritar e desfavoritar filmes, além de exibir uma tela dedicada aos favoritos.

### O app foi criado com foco em:
- Arquitetura clara (**MVVM**)
- Layout programático (**View Code**)
- Componentização
- Clean Code
- Testes unitários e testes UI
- Modularização por camadas
- Uso de **Swift Package Manager** e **Kingfisher**

---

## 🛠 Tecnologias Utilizadas

- Swift 5+
- Xcode 26.1.1
- UIKit
- View Code
- MVVM
- URLSession
- TheMovieDB API
- UserDefaults para persistência básica
- XCTest (Unit Tests)
- XCUITest (UI Tests)

---

## ▶️ Como Executar o Projeto

### 1. Clonar o repositório


git clone https://github.com/yagocomy/MovieApp.git


2. Abrir o projeto
Abra o arquivo:
MovieApp.xcodeproj

Nenhuma configuração extra é necessária além da API Key.


## 🔑 Configuração da API (IMPORTANTE)

O app utiliza a API pública do TheMovieDB, e para funcionar é obrigatório inserir:
-  API Key v3
-  Bearer Token v4
-  Como gerar:
-  Acesse https://www.themoviedb.org
-  Crie uma conta
-  Vá em Settings → API
-  Gere sua API Key e Token - [https://developer.themoviedb.org/docs/authentication-application](https://www.themoviedb.org/settings/api)

Edite o Arquivo ApiKey.json

⚠️ Sem este passo o app não faz requisições.


## 📱 Funcionalidades do APP
-  Listagem de filmes populares
-  Busca por filmes
-  Exibição de título, imagem e descrição
-  Expand/Collapse da sinopse
-  Favoritar e desfavoritar Filmes
-  Tela dedicada aos favoritos
-  Estado de lista vazia com UI personalizada
-  Tela de loading
-  Tratamento de erro e fallback visual


### 🧠 Decisões Técnicas e Motivação
## 🧩 MVVM
Escolhido para:
-  Separar responsabilidades
-  Facilitar testes unitários
-  Manter a ViewController mais limpa
-  Criar bindings simples entre ViewModel e View
## 🧩 View Code
-  Utilizei View Code para:
-  Garantir controle total sobre o layout
-  Evitar conflitos de Storyboard
-  Manter um fluxo de desenvolvimento mais escalável
-  Facilitar reutilização de componentes
## 🧩 Persistência de dados
-  Foi utilizado Swift Data para salvar localmente os dados.
## 🧩 Tela de favoritos vazia
-  A tela de favoritos exibe:
-  Loading
-   Coração e texto estilizado
-  Estado vazio sem tratar como erro
-  Essa decisão foi tomada porque o caso "nenhum favorito" não representa falha da API.

## 🧪 Testes
## ✔️ Testes Unitários
-  Testes da ViewModel
-  Testes de formatação
-  Testes de persistência
-  Testes de fluxo de favoritar/desfavoritar
## ✔️ Testes de UI
-  Fluxo de navegação
-  Busca
-  Favoritar / desfavoritar
-  Verificação da tela vazia
