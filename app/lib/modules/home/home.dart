import 'package:app/modules/home/HomepageHeader.dart';
import 'package:app/modules/home/HomepageSectionList.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
          children: [
            HomepageHeader(),
            HomepageSectionList(sections: [Section("asd", ""), Section("MockSection", "")])
          ]
      ),
    );
  }
}