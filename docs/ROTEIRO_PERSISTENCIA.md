# Roteiro de apresentação — Persistência (SQLite)

Tempo alvo: 5 a 8 minutos.

## Parte 1 — O que foi feito (fala, ~1 min)

> "Nesta etapa adicionei persistência local ao app com SQLite, usando o pacote
> sqflite. A funcionalidade escolhida foi a de **favoritos**: antes eles ficavam
> só em memória e sumiam ao fechar o app; agora são gravados num banco local e
> continuam disponíveis depois de reiniciar."

Por que favoritos (justificativa da escolha):
- As notícias vêm de uma API e mudam o tempo todo → não faz sentido persistir o feed.
- Os favoritos são uma escolha do usuário, que ele espera reencontrar depois.

## Parte 2 — Demonstração (o ponto mais importante)

1. Faça login e abra uma notícia → toque em **Salvar**.
2. Abra **Favoritos** (ícone no topo) → mostre a notícia salva.
3. Edite a **nota pessoal** de um favorito (UPDATE).
4. Use a **busca** para filtrar por título ou nota (desafio SQL LIKE).
5. **FECHE o app e abra de novo** → mostre que o favorito continua lá.
   *(este é o momento-chave: prova a persistência)*
6. Remova um favorito (DELETE).

## Parte 3 — Tour rápido pelo código

**`lib/core/models/favorite.dart`**
"Classe de modelo da entidade, com `toMap()` e `fromMap()` — a conversão entre
objeto e banco."

**`lib/core/db/app_database.dart`**
"Camada do banco: no `onCreate` a tabela é criada automaticamente. Aqui estão o
CRUD (`insert`, `getAll`, `update`, `delete`) e a **busca com SQL LIKE**. Tudo
assíncrono com async/await."

**`lib/modules/favorites/saved_articles_screen.dart`**
"A interface: lista, busca, editar nota e excluir."

**`lib/app/main.dart`**
"No desktop ativo a fábrica FFI do sqflite para o banco rodar no Linux."

## Parte 4 — Decisões técnicas (para citar)

- Chave primária = URL da notícia → evita duplicados.
- `sqflite` no mobile + `sqflite_common_ffi` no desktop (mesma API).
- Camada `AppDatabase` isolada para manter as telas simples.

> Dica: já testei a camada do banco de forma automatizada
> (`dart run tool/db_check.dart`) — insere, fecha, reabre e confirma que o dado
> persiste. Pode ser citado como validação.
