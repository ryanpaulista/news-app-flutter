import 'package:app/core/models/article.dart';
import 'package:flutter/foundation.dart';

class FavoritesStore extends ChangeNotifier {
  final Set<String> _ids = <String>{};

  bool isFavorite(String id) => _ids.contains(id);

  int get count => _ids.length;

  bool toggle(String id) {
    final bool nowFavorite = !_ids.contains(id);
    if (nowFavorite) {
      _ids.add(id);
    } else {
      _ids.remove(id);
    }
    debugPrint(
      '[FavoritesStore] toggle id=$id -> favorite=$nowFavorite (total=${_ids.length})',
    );
    notifyListeners();
    return nowFavorite;
  }

  List<Article> favoritesOf(List<Article> all) =>
      all.where((a) => _ids.contains(a.id)).toList();
}

final FavoritesStore favoritesStore = FavoritesStore();
