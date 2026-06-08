import 'package:app/modules/home/home_search_bar.dart';
import 'package:flutter/material.dart';

class HomepageHeader extends StatelessWidget {
  final VoidCallback onMenuTap;
  final VoidCallback onOpenFavorites;

  const HomepageHeader({
    super.key,
    required this.onMenuTap,
    required this.onOpenFavorites,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12)),
      ),
      child: HomeSearchBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          tooltip: 'Menu',
          iconSize: 28,
          onPressed: onMenuTap,
        ),
        title: const Text(
          'NewsHub',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border_outlined),
            tooltip: 'Favoritos',
            onPressed: onOpenFavorites,
            iconSize: 28,
          ),
        ],
      ),
    );
  }
}
