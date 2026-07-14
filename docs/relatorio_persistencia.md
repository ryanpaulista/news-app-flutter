# Relatório — Persistência local com SQLite

**Aplicação:** NewsHub (Flutter) · **Banco:** SQLite via `sqflite`

## 1. Funcionalidades que passaram a usar persistência

Antes, os favoritos ficavam apenas em memória (um conjunto de IDs) e eram
perdidos ao fechar o aplicativo. Agora, **salvar uma notícia nos favoritos**
grava o registro em um banco SQLite local, e a tela **"Favoritos salvos"** lê
esses dados do banco. Assim, os favoritos permanecem disponíveis mesmo após
reiniciar o app.

Operações disponíveis na interface (CRUD completo):

- **Inserir:** botão "Salvar" na tela de detalhe da notícia (e o ícone de
  marcador na lista);
- **Listar:** tela de favoritos salvos;
- **Atualizar:** edição de uma **nota pessoal** em cada favorito;
- **Excluir:** botão de remover em cada item;
- **Buscar (desafio):** campo de busca que filtra por título ou nota usando
  uma consulta SQL `LIKE`.

Toda a comunicação com o banco é assíncrona (`Future` / `async` / `await`).

## 2. Justificativa da escolha dos dados persistidos

Analisando o domínio (um leitor de notícias), a informação que mais se
beneficia de armazenamento permanente é a **lista de notícias favoritas**. As
notícias em si vêm de uma API e são voláteis/atualizadas o tempo todo; não faz
sentido persistir o feed inteiro. Já os favoritos representam uma **escolha do
usuário**, que ele espera reencontrar depois — inclusive offline. Persistir os
favoritos (com uma nota pessoal opcional) é o uso mais natural e útil de um
banco local neste app.

## 3. Estrutura do banco de dados

Banco `newshub.db`, uma tabela:

**Tabela `favorites`**

| Coluna | Tipo | Descrição |
|---|---|---|
| `id` | TEXT (PK) | URL da notícia (identificador único) |
| `title` | TEXT | Título |
| `author` | TEXT | Autor/fonte |
| `publishedAt` | TEXT | Data de publicação |
| `imageUrl` | TEXT | Imagem |
| `note` | TEXT | Nota pessoal (editável) |
| `savedAt` | TEXT | Data/hora em que foi salvo (ordenação) |

O banco e a tabela são criados **automaticamente** na primeira execução
(callback `onCreate`). A conversão objeto ↔ banco é feita pelos métodos
`toMap()` e `Favorite.fromMap()` da classe de modelo `Favorite`.

## 4. Principais decisões técnicas

- **Chave primária = URL da notícia:** evita favoritos duplicados de forma
  simples (uso de `ConflictAlgorithm.replace`).
- **`sqflite` + `sqflite_common_ffi`:** o `sqflite` cobre Android/iOS; para
  rodar e demonstrar no **desktop (Linux)** foi adicionado o
  `sqflite_common_ffi`, que fornece a mesma API sobre a biblioteca nativa
  `libsqlite3`. Em `main()` a fábrica FFI é ativada apenas em desktop.
- **Camada de acesso isolada:** a classe `AppDatabase` concentra abertura do
  banco e todas as operações de CRUD e busca, mantendo as telas simples.

## 5. Antes x depois (para os prints)

- **Antes:** salvar um favorito e fechar o app → ao reabrir, a lista estava vazia.
- **Depois:** salvar um favorito, **fechar e reabrir** o app → o favorito
  continua lá, com a nota pessoal preservada.
