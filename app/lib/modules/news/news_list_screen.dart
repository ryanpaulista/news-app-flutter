import 'package:app/app/routes.dart';
import 'package:app/core/db/app_database.dart';
import 'package:app/core/models/article.dart';
import 'package:app/core/models/favorite.dart';
import 'package:app/core/services/app_exceptions.dart';
import 'package:app/core/services/news_api_service.dart';
import 'package:app/core/services/secure_storage_service.dart';
import 'package:app/modules/article/news_detail_screen.dart';
import 'package:app/modules/favorites/saved_articles_screen.dart';
import 'package:app/modules/home/news_card.dart';
import 'package:flutter/material.dart';

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({super.key});

  @override
  State<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  final _db = AppDatabase.instance;

  bool _loading = true;
  String? _error;
  List<Article> _articles = const [];
  Set<String> _favoriteIds = <String>{};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _refreshFavorites() async {
    final favorites = await _db.getAll();
    if (!mounted) return;
    setState(() => _favoriteIds = favorites.map((f) => f.id).toSet());
  }

  Future<void> _toggleFavorite(Article article) async {
    if (_favoriteIds.contains(article.id)) {
      await _db.delete(article.id);
    } else {
      final savedAt = DateTime.now().toIso8601String();
      await _db.insert(Favorite.fromArticle(article, savedAt));
    }
    await _refreshFavorites();
  }

  Future<void> _openFavorites() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SavedArticlesScreen()),
    );
    await _refreshFavorites();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final token = await secureStorage.readToken();
      if (token == null || token.isEmpty) {
        throw const UnauthorizedException();
      }

      final articles = await newsApi.fetchTopHeadlines(token);
      await _refreshFavorites();
      if (!mounted) return;
      setState(() => _articles = articles);
    } on UnauthorizedException {
      // Token inválido/expirado: remove do storage e volta ao login.
      await _logout();
    } on AppException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _logout() async {
    await secureStorage.clearToken();
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(AppRoutes.login);
  }

  Future<void> _openArticle(Article article) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => NewsDetailScreen(article: article)),
    );
    await _refreshFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notícias'),
        actions: [
          IconButton(
            onPressed: _openFavorites,
            icon: const Icon(Icons.bookmark),
            tooltip: 'Favoritos',
          ),
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.grey.shade500),
              const SizedBox(height: 12),
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _load,
                icon: const Icon(Icons.refresh),
                label: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _articles.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (_, i) {
          final article = _articles[i];
          return NewsCard(
            title: article.title,
            author: article.author,
            postedAt: article.postedAt,
            imageUrl: article.imageUrl,
            isFavorite: _favoriteIds.contains(article.id),
            onTap: () => _openArticle(article),
            onToggleFavorite: () => _toggleFavorite(article),
          );
        },
      ),
    );
  }
}
