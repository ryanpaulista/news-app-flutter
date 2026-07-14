# Guia de apresentação

## Como rodar

1. Pegue uma chave gratuita em https://newsapi.org e cole em
   `app/lib/core/config.dart` → `AppConfig.newsApiKey`.
2. No diretório `app/`:
   ```
   flutter pub get
   flutter run
   ```
3. Login de teste: **admin / 1234**.

## Onde cada requisito está no código

| Requisito | Arquivo |
|---|---|
| Tela de login (envia credenciais) | `lib/modules/auth/login_screen.dart` |
| Armazenamento seguro do token | `lib/core/services/secure_storage_service.dart` |
| Requisição HTTP GET protegida (header de autorização) | `lib/core/services/news_api_service.dart` |
| Resposta JSON desserializada em lista | `lib/core/models/article.dart` (`fromJson`) + `lib/modules/news/news_list_screen.dart` |
| 401 → remove token → volta ao login | `news_list_screen.dart` (`_load` / `_logout`) |
| HTTPS | `lib/core/config.dart` (`newsApiBaseUrl`) |
| Tratamento de erros | `lib/core/services/app_exceptions.dart` + `news_api_service.dart` |
| Uso correto de SharedPreferences | `lib/core/services/prefs_service.dart` |
| Entrada automática após login | `lib/app/main.dart` (`_Bootstrap`) |

## Cenários de erro tratados

- **Servidor indisponível** → `ServerUnavailableException` (`SocketException`)
- **Timeout** → `ConnectionTimeoutException` (`.timeout`)
- **Credenciais inválidas** → `InvalidCredentialsException` (login)
- **Token expirado/inválido (401)** → `UnauthorizedException` → limpa token e vai ao login
- **JSON inválido** → `InvalidResponseException`
- **Falha no armazenamento seguro** → `SecureStorageException`

## Screenshots sugeridos (4 a 6)

1. Tela de login preenchida.
2. Lista de notícias carregada (consulta ao endpoint protegido).
3. Erro de credenciais inválidas (senha errada).
4. Token inválido: com uma chave errada em `config.dart`, o app cai no login (401).
5. Falha de comunicação: sem internet, a tela mostra "Servidor indisponível".
6. (Opcional) Detalhe de uma notícia.
