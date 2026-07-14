class Article {
  final String id;
  final String title;
  final String author;
  final String postedAt;
  final String imageUrl;
  final String summary;
  final String body;
  final String url;

  const Article({
    required this.id,
    required this.title,
    required this.author,
    required this.postedAt,
    required this.imageUrl,
    required this.summary,
    required this.body,
    this.url = '',
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    final source = json['source'] as Map<String, dynamic>?;
    final sourceName = source?['name'] as String?;
    final url = json['url'] as String? ?? '';

    return Article(
      id: url.isNotEmpty ? url : (json['title'] as String? ?? ''),
      title: json['title'] as String? ?? 'Sem título',
      author: json['author'] as String? ?? sourceName ?? 'Autor desconhecido',
      postedAt: _formatDate(json['publishedAt'] as String?),
      imageUrl: json['urlToImage'] as String? ?? '',
      summary: json['description'] as String? ?? '',
      body: json['content'] as String? ?? json['description'] as String? ?? '',
      url: url,
    );
  }

  static String _formatDate(String? iso) {
    if (iso == null || iso.length < 10) return '';
    return iso.substring(0, 10);
  }
}
