class AppConfig {
  AppConfig._();

  // Crie uma chave gratuita em https://newsapi.org e cole aqui.
  static const String newsApiKey = '28f1d6feb73a4575baee29388b2dc734';

  static const String newsApiBaseUrl = 'https://newsapi.org/v2';

  static const String demoUsername = 'admin';
  static const String demoPassword = '1234';

  static const Duration requestTimeout = Duration(seconds: 15);
}
