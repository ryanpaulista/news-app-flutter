import 'package:app/app/routes.dart';
import 'package:app/core/data/mock_articles.dart';
import 'package:app/core/favorites_store.dart';
import 'package:app/core/models/article.dart';
import 'package:app/modules/home/HomepageHeader.dart';
import 'package:app/modules/home/HomepageSectionList.dart';
import 'package:app/modules/home/news_card.dart';
import 'package:flutter/material.dart';

/// Root screen of the Início tab — the news feed.
///
/// Tapping a card pushes the detail screen onto this tab's nested navigator
/// with the [Article] as named-route arguments (req #4) and awaits a result
/// (req #5). [onMenuTap] opens the shared Drawer; [onOpenFavorites] jumps to
/// the Favoritos tab.
class HomePage extends StatelessWidget {
  final VoidCallback onMenuTap;
  final VoidCallback onOpenFavorites;

  const HomePage({
    super.key,
    required this.onMenuTap,
    required this.onOpenFavorites,
  });

  static const _sections = <Section>[
    Section("Top", ""),
    Section("World", ""),
    Section("Tech", ""),
    Section("Sports", ""),
    Section("Business", ""),
  ];

  Future<void> _openArticle(BuildContext context, Article article) async {
    debugPrint('[Home] push ${AppRoutes.article} id=${article.id}');
    final result = await Navigator.of(
      context,
    ).pushNamed(AppRoutes.article, arguments: article);
    debugPrint('[Home] back from detail, result(isFavorite)=$result');

    if (result == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notícia salva nos favoritos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            HomepageHeader(
              onMenuTap: onMenuTap,
              onOpenFavorites: onOpenFavorites,
            ),
            const HomepageSectionList(sections: _sections),
            Expanded(
              child: ListenableBuilder(
                listenable: favoritesStore,
                builder: (context, _) {
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(10, 4, 10, 16),
                    itemCount: mockArticles.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final article = mockArticles[index];
                      return NewsCard(
                        title: article.title,
                        author: article.author,
                        postedAt: article.postedAt,
                        imageUrl: article.imageUrl,
                        isFavorite: favoritesStore.isFavorite(article.id),
                        onTap: () => _openArticle(context, article),
                        onToggleFavorite: () =>
                            favoritesStore.toggle(article.id),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
