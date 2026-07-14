import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app/core/config.dart';
import 'package:app/core/models/article.dart';
import 'package:app/core/services/app_exceptions.dart';
import 'package:http/http.dart' as http;

class NewsApiService {
  Future<List<Article>> fetchTopHeadlines(String token) async {
    final uri = Uri.parse(
      '${AppConfig.newsApiBaseUrl}/top-headlines?country=us&pageSize=30',
    );

    late final http.Response response;
    try {
      response = await http
          .get(uri, headers: {'X-Api-Key': token})
          .timeout(AppConfig.requestTimeout);
    } on TimeoutException {
      throw const ConnectionTimeoutException();
    } on SocketException {
      throw const ServerUnavailableException();
    }

    if (response.statusCode == 401) {
      throw const UnauthorizedException();
    }
    if (response.statusCode != 200) {
      throw const InvalidResponseException();
    }

    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final articles = (body['articles'] as List)
          .cast<Map<String, dynamic>>()
          .map(Article.fromJson)
          .toList();
      return articles;
    } catch (_) {
      throw const InvalidResponseException();
    }
  }
}

final newsApi = NewsApiService();
