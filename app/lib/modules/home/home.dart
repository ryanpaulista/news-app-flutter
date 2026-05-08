import 'package:app/modules/home/HomepageHeader.dart';
import 'package:app/modules/home/HomepageSectionList.dart';
import 'package:app/modules/home/news_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
          children: [
            HomepageHeader(),
            HomepageSectionList(sections: [Section("asd", ""), Section("MockSection", "")]),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: NewsCard(title: "teste", author: "BBC", postedAt: "2026-05-02", imageUrl: ""),
            ),
          ]
      ),
    );
  }
}