# Relatório — Comunicação segura entre app Flutter e API REST

**Aplicação:** NewsHub (Flutter) · **API:** NewsAPI (https://newsapi.org) · HTTPS

## 1. Justificativa para o uso de `flutter_secure_storage`

O token de acesso é uma credencial: quem o possui consegue agir em nome do
usuário. Por isso ele é gravado no `flutter_secure_storage`, que armazena os
dados de forma criptografada usando os mecanismos nativos do sistema
operacional — **Keychain** no iOS e **Keystore/EncryptedSharedPreferences** no
Android. As chaves ficam protegidas pelo hardware/OS e não são acessíveis por
outros aplicativos nem por leitura direta de arquivos do app.

## 2. Quando usar `SharedPreferences`

O `SharedPreferences` guarda dados em **texto puro**, em um arquivo XML acessível
com relativa facilidade em dispositivos comprometidos (root/jailbreak) ou por
backups. Ele é adequado para **informações não sensíveis**, como:

- tema da interface (claro/escuro);
- última pesquisa realizada;
- preferências de exibição e flags simples de configuração.

**Não** deve ser usado para tokens ou credenciais, justamente por não oferecer
criptografia. No projeto ele é usado apenas para tema e última busca
(`prefs_service.dart`).

## 3. Papel do HTTPS na proteção dos dados em trânsito

Todas as requisições usam HTTPS. O HTTPS aplica **TLS** sobre o HTTP,
garantindo:

- **Confidencialidade:** os dados trafegam criptografados; um atacante na rede
  vê apenas conteúdo cifrado.
- **Integridade:** adulterações no caminho são detectadas.
- **Autenticidade:** o certificado do servidor confirma que estamos falando com
  o host correto, dificultando ataques *man-in-the-middle*.

Em HTTP puro (comum apenas em desenvolvimento), token e respostas trafegam em
texto claro e podem ser capturados. Ao migrar para produção com HTTPS, esse
tráfego passa a ser cifrado ponta a ponta, eliminando essa exposição.

## 4. Necessidade (ou não) do pacote `Encrypt`

**O HTTPS já protege os dados transmitidos?** Sim — para dados *em trânsito*, o
TLS do HTTPS já garante confidencialidade, integridade e autenticidade. Não é
necessário cifrar novamente o corpo das requisições para protegê-las na rede.

**Quando uma camada extra com `Encrypt` seria necessária?** Para proteger dados
*em repouso* ou casos específicos: cifrar um payload sensível antes de gravá-lo
localmente, criptografia ponta a ponta (em que nem o servidor deve ler o
conteúdo), ou quando há exigência regulatória de cifra adicional da carga.

**Vantagens e desvantagens.** Vantagem: proteção mesmo que o transporte ou o
armazenamento sejam comprometidos. Desvantagens: maior complexidade,
necessidade de **gestão de chaves** (o ponto mais crítico — uma chave embutida
no app é facilmente extraível), e custo de manutenção.

**Conclusão:** neste projeto o `Encrypt` **não é necessário**. O tráfego já é
protegido pelo HTTPS e o token sensível é armazenado pelo `flutter_secure_storage`,
que já cifra os dados em repouso. Uma cifra adicional traria complexidade sem
ganho real de segurança para este escopo.

## 5. Decisão de projeto: autenticação

A NewsAPI autentica por **API key** (não emite JWT via login usuário/senha).
Para atender ao fluxo da atividade mantendo o tema de notícias, foi adotado um
**login de fachada** (usuário/senha validados no app) que, ao ter sucesso,
grava o token de acesso no `flutter_secure_storage`. A tela de consulta
**recupera esse token do armazenamento seguro** e o envia no cabeçalho de
autenticação da requisição protegida. Um retorno **401** faz o app tratar o
token como inválido, removê-lo do storage e redirecionar para o login —
exatamente o ciclo de proteção pedido.

## 6. Principais dificuldades

- Compreender a diferença prática entre armazenamento seguro e `SharedPreferences`.
- Mapear e tratar todos os cenários de erro (servidor indisponível, timeout,
  credenciais inválidas, 401, JSON inválido e falha no armazenamento seguro).
- Garantir o redirecionamento automático ao login quando o token é rejeitado.
