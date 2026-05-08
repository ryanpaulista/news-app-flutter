import 'package:flutter/material.dart';

class Section {
  String title = "";
  String linkTo = "";

  Section(this.title, this.linkTo);
}

class HomepageSectionList extends StatelessWidget {
  final List<Section> sections;

  const HomepageSectionList({super.key, required this.sections});

  @override
  Widget build(BuildContext context){
    return Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          spacing: 15,
          children: sections.map((Section s) {
            return Container(
              height: 30,
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              decoration: const BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(8))),
              child: Text(s.title, style: TextStyle(color: Colors.black87, fontWeight: FontWeight(500)),),
            );
          }).toList()
        )
    );
  }
}