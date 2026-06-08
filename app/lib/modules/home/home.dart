import 'package:app/modules/home/HomepageHeader.dart';
import 'package:app/modules/home/HomepageSectionList.dart';
import 'package:app/modules/home/news_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const _sections = <Section>[
    Section("Top", ""),
    Section("World", ""),
    Section("Tech", ""),
    Section("Sports", ""),
    Section("Business", ""),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const HomepageHeader(),
          const HomepageSectionList(sections: _sections),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(10, 4, 10, 16),
              itemCount: 6,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) => const NewsCard(
                title: "Sample headline that demonstrates how a long title wraps inside the card",
                author: "BBC",
                postedAt: "2026-05-02",
                imageUrl: "",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
