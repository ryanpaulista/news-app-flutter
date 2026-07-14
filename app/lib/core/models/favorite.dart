import 'package:app/core/models/article.dart';

class Favorite {
  final String id;
  final String title;
  final String author;
  final String publishedAt;
  final String imageUrl;
  final String note;
  final String savedAt;

  const Favorite({
    required this.id,
    required this.title,
    required this.author,
    required this.publishedAt,
    required this.imageUrl,
    this.note = '',
    required this.savedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'publishedAt': publishedAt,
      'imageUrl': imageUrl,
      'note': note,
      'savedAt': savedAt,
    };
  }

  factory Favorite.fromMap(Map<String, dynamic> map) {
    return Favorite(
      id: map['id'] as String,
      title: map['title'] as String,
      author: map['author'] as String,
      publishedAt: map['publishedAt'] as String,
      imageUrl: map['imageUrl'] as String,
      note: map['note'] as String? ?? '',
      savedAt: map['savedAt'] as String,
    );
  }

  factory Favorite.fromArticle(Article article, String savedAt) {
    return Favorite(
      id: article.id,
      title: article.title,
      author: article.author,
      publishedAt: article.postedAt,
      imageUrl: article.imageUrl,
      savedAt: savedAt,
    );
  }

  Favorite copyWith({String? note}) {
    return Favorite(
      id: id,
      title: title,
      author: author,
      publishedAt: publishedAt,
      imageUrl: imageUrl,
      note: note ?? this.note,
      savedAt: savedAt,
    );
  }
}
