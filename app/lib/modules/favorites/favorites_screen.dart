import 'package:app/app/routes.dart';
import 'package:app/core/data/mock_articles.dart';
import 'package:app/core/favorites_store.dart';
import 'package:app/core/models/article.dart';
import 'package:app/modules/home/news_card.dart';
import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  final VoidCallback onMenuTap;

  const FavoritesScreen({super.key, required this.onMenuTap});

  Future<void> _openArticle(BuildContext context, Article article) async {
    debugPrint('[Favorites] push ${AppRoutes.article} id=${article.id}');
    await Navigator.of(context).pushNamed(AppRoutes.article, arguments: article);
    debugPrint('[Favorites] back from ${AppRoutes.article}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          tooltip: 'Menu',
          onPressed: onMenuTap,
        ),
      ),
      body: ListenableBuilder(
        listenable: favoritesStore,
        builder: (context, _) {
          final favorites = favoritesStore.favoritesOf(mockArticles);
          if (favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.bookmark_border,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Nenhuma notícia salva ainda',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(10),
            itemCount: favorites.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final article = favorites[index];
              return NewsCard(
                title: article.title,
                author: article.author,
                postedAt: article.postedAt,
                imageUrl: article.imageUrl,
                isFavorite: true,
                onTap: () => _openArticle(context, article),
                onToggleFavorite: () => favoritesStore.toggle(article.id),
              );
            },
          );
        },
      ),
    );
  }
}
