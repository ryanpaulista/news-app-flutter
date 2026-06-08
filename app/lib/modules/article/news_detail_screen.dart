import 'package:app/core/favorites_store.dart';
import 'package:app/core/models/article.dart';
import 'package:flutter/material.dart';

class NewsDetailScreen extends StatelessWidget {
  final Article article;

  const NewsDetailScreen({super.key, required this.article});

  void _close(BuildContext context) {
    final bool result = favoritesStore.isFavorite(article.id);
    debugPrint('[Detail] pop result(isFavorite)=$result id=${article.id}');
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.author),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Voltar',
          onPressed: () => _close(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Icon(Icons.image, size: 48, color: Colors.grey.shade500),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            article.title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '${article.author} • ${article.postedAt}',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          Text(article.body, style: const TextStyle(fontSize: 16, height: 1.5)),
        ],
      ),
      floatingActionButton: ListenableBuilder(
        listenable: favoritesStore,
        builder: (context, _) {
          final bool fav = favoritesStore.isFavorite(article.id);
          return FloatingActionButton.extended(
            onPressed: () => favoritesStore.toggle(article.id),
            icon: Icon(fav ? Icons.bookmark : Icons.bookmark_border),
            label: Text(fav ? 'Salvo' : 'Salvar'),
          );
        },
      ),
    );
  }
}
