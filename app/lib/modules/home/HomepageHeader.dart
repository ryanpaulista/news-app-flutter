import 'package:flutter/material.dart';

class HomepageHeader extends StatelessWidget {
  const HomepageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "NewsHub",
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          Row(
            children: const [
              IconButton(
                icon: Icon(Icons.search),
                tooltip: "Search",
                onPressed: null,
                iconSize: 28,
              ),
              IconButton(
                icon: Icon(Icons.bookmark_border_outlined),
                tooltip: "Favorites",
                onPressed: null,
                iconSize: 28,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
