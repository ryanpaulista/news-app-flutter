class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => message;
}

// Não foi possível alcançar o servidor (sem rede / host fora do ar).
class ServerUnavailableException extends AppException {
  const ServerUnavailableException()
    : super('Servidor indisponível. Verifique sua conexão e tente novamente.');
}

class ConnectionTimeoutException extends AppException {
  const ConnectionTimeoutException()
    : super('Tempo de conexão esgotado. Tente novamente.');
}

class InvalidCredentialsException extends AppException {
  const InvalidCredentialsException()
    : super('Usuário ou senha inválidos.');
}

// 401 vindo da API: token ausente, inválido ou expirado.
class UnauthorizedException extends AppException {
  const UnauthorizedException()
    : super('Sessão expirada. Faça login novamente.');
}

class InvalidResponseException extends AppException {
  const InvalidResponseException()
    : super('Resposta inesperada do servidor.');
}

class SecureStorageException extends AppException {
  const SecureStorageException()
    : super('Falha ao acessar o armazenamento seguro.');
}
