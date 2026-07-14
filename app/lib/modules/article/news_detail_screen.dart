import 'package:app/core/db/app_database.dart';
import 'package:app/core/models/article.dart';
import 'package:app/core/models/favorite.dart';
import 'package:flutter/material.dart';

class NewsDetailScreen extends StatefulWidget {
  final Article article;

  const NewsDetailScreen({super.key, required this.article});

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  final _db = AppDatabase.instance;
  bool _isFavorite = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    final exists = await _db.exists(widget.article.id);
    if (!mounted) return;
    setState(() {
      _isFavorite = exists;
      _loading = false;
    });
  }

  Future<void> _toggle() async {
    if (_isFavorite) {
      await _db.delete(widget.article.id);
    } else {
      final savedAt = DateTime.now().toIso8601String();
      await _db.insert(Favorite.fromArticle(widget.article, savedAt));
    }
    if (!mounted) return;
    setState(() => _isFavorite = !_isFavorite);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isFavorite ? 'Salvo nos favoritos' : 'Removido'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final article = widget.article;
    return Scaffold(
      appBar: AppBar(title: Text(article.author)),
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
      floatingActionButton: _loading
          ? null
          : FloatingActionButton.extended(
              onPressed: _toggle,
              icon: Icon(_isFavorite ? Icons.bookmark : Icons.bookmark_border),
              label: Text(_isFavorite ? 'Salvo' : 'Salvar'),
            ),
    );
  }
}
