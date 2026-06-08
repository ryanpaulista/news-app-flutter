import 'package:flutter/material.dart';

class NewsCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String author;
  final String postedAt;
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onToggleFavorite;

  const NewsCard({
    super.key,
    required this.title,
    required this.author,
    required this.postedAt,
    required this.imageUrl,
    this.isFavorite = false,
    this.onTap,
    this.onToggleFavorite,
  });

  static const _horizontalBreakpoint = 600.0;

  @override
  Widget build(BuildContext context) {
    const radius = 10.0;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(radius),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= _horizontalBreakpoint) {
              return _buildHorizontal(constraints.maxWidth);
            }
            return _buildVertical();
          },
        ),
      ),
    );
  }

  Widget _buildVertical() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: _CardImage(imageUrl: imageUrl),
        ),
        _buildBody(const EdgeInsets.fromLTRB(12, 10, 8, 10), 2),
      ],
    );
  }

  Widget _buildHorizontal(double maxWidth) {
    final imageWidth = (maxWidth * 0.32).clamp(160.0, 260.0);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: imageWidth,
            child: _CardImage(imageUrl: imageUrl),
          ),
          Expanded(
            child: _buildBody(const EdgeInsets.fromLTRB(14, 12, 8, 12), 2),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(EdgeInsets padding, int titleMaxLines) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            maxLines: titleMaxLines,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  "$author • $postedAt",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.bookmark : Icons.bookmark_add_outlined,
                ),
                color: isFavorite ? Colors.deepPurple : Colors.grey.shade600,
                iconSize: 20,
                visualDensity: VisualDensity.compact,
                tooltip: isFavorite ? "Remover" : "Salvar",
                onPressed: onToggleFavorite,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CardImage extends StatelessWidget {
  final String imageUrl;

  const _CardImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return Container(color: Colors.grey.shade300);
    }

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          color: Colors.grey.shade200,
          alignment: Alignment.center,
          child: const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
      errorBuilder: (context, error, stack) => Container(
        color: Colors.grey.shade300,
        alignment: Alignment.center,
        child: Icon(Icons.broken_image_outlined, color: Colors.grey.shade500),
      ),
    );
  }
}
