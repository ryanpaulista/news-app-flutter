# Roteiro de apresentação

## Parte 1 — Explicação (o que falar, ~1 a 2 min)

> "O objetivo do trabalho é demonstrar a comunicação segura entre um app
> Flutter e uma API REST. O app faz login, guarda a credencial de acesso de
> forma segura, usa essa credencial para consultar um endpoint protegido por
> HTTPS, e trata os erros e o caso de sessão inválida.
>
> A API que usei é a NewsAPI. Como ela autentica por chave de acesso, essa
> chave faz o papel do token: depois do login ela é guardada no
> flutter_secure_storage e enviada no cabeçalho de cada requisição."

Pontos-chave para citar:
- **flutter_secure_storage** guarda o token cifrado (Keychain/Keystore). Token é credencial → precisa de armazenamento seguro.
- **SharedPreferences** é texto puro → só para dados não sensíveis (tema, última busca). Nunca para token.
- **HTTPS** garante que os dados trafegam cifrados (confidencialidade, integridade e autenticidade).
- **401** → o app considera o token inválido, apaga do storage e volta ao login.
- Tratei **6 cenários de erro**: servidor indisponível, timeout, credenciais inválidas, token expirado (401), JSON inválido e falha no armazenamento seguro.

## Parte 2 — Tour pelo código (o que abrir e o que dizer)

**1. `lib/core/config.dart`**
"Aqui ficam a base HTTPS da API e as credenciais de teste. Note o `https://`."

**2. `lib/modules/auth/login_screen.dart` → método `_login()`**
"Valido as credenciais e, se o login der certo, **salvo o token no armazenamento
seguro** e vou para a tela de notícias. Se estiverem erradas, lanço
`InvalidCredentialsException`."

**3. `lib/core/services/secure_storage_service.dart`**
"É o wrapper do flutter_secure_storage: `saveToken`, `readToken` e `clearToken`,
todos protegidos com try/catch."

**4. `lib/core/services/news_api_service.dart` → `fetchTopHeadlines()`**
"Requisição GET com o token no cabeçalho de autorização. Tem **timeout**, trato
`SocketException` como servidor indisponível, e **se vier 401 lanço
`UnauthorizedException`**. O JSON é convertido em objetos com try/catch."

**5. `lib/core/services/app_exceptions.dart`**
"Cada cenário de erro exigido virou uma exceção nomeada."

**6. `lib/modules/news/news_list_screen.dart` → `_load()` e `_logout()`**
"Ao abrir, **recupero o token do storage** e faço a consulta. Se der 401,
**apago o token e redireciono para o login** automaticamente."

**7. `lib/core/services/prefs_service.dart`**
"Aqui uso SharedPreferences só para tema e última busca — dados não sensíveis."

## Parte 3 — Demonstração ao vivo (rápida)

1. Login com `admin` / `1234` → lista de notícias carrega (consulta protegida).
2. (Opcional) Senha errada → mensagem de credenciais inválidas.
3. (Opcional) Wi-Fi desligado + "Tentar novamente" → "Servidor indisponível".
4. Botão **Sair** → volta ao login (mostra o ciclo completo).

> Lembrete: rodar `build/linux/x64/release/bundle/app` e ter internet.

## Parte 4 — Perguntas prováveis do professor (e respostas)

**Por que flutter_secure_storage e não SharedPreferences para o token?**
Porque SharedPreferences guarda em texto puro; o token é uma credencial e
precisa ficar cifrado. O secure storage usa Keychain (iOS) e Keystore (Android).

**O que pode ir no SharedPreferences então?**
Dados não sensíveis: tema da interface, última busca, preferências de exibição.

**O HTTPS sozinho já não basta?**
Para os dados em trânsito, sim — o TLS garante confidencialidade, integridade e
autenticidade. Uma cifra extra (pacote Encrypt) só faria sentido para proteger
dados em repouso ou cenários de ponta a ponta, o que não é o caso aqui.

**O que acontece se o token expirar?**
A API responde 401; o app trata como token inválido, apaga do storage e
redireciona para o login.

**Isso é JWT de verdade?**
Não. A NewsAPI autentica por chave de acesso, então a chave faz o papel do
token. O mecanismo de guarda segura, uso no cabeçalho e tratamento de 401 é o
mesmo — é uma decisão de projeto documentada no relatório.

**Como você tratou falha de rede?**
Capturo `SocketException` (servidor indisponível) e uso `.timeout()` para o
tempo de conexão; ambos viram mensagens claras com botão de tentar novamente.
