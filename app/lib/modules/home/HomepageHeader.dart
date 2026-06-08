import 'package:app/modules/home/home_search_bar.dart';
import 'package:flutter/material.dart';

class HomepageHeader extends StatelessWidget {
  const HomepageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12)),
      ),
      child: const HomeSearchBar(
        title: Text(
          'NewsHub',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark_border_outlined),
            tooltip: 'Favorites',
            onPressed: null,
            iconSize: 28,
          ),
        ],
      ),
    );
  }
}
