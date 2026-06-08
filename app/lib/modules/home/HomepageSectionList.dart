import 'package:flutter/material.dart';

class Section {
  final String title;
  final String linkTo;

  const Section(this.title, this.linkTo);
}

class HomepageSectionList extends StatelessWidget {
  final List<Section> sections;

  const HomepageSectionList({super.key, required this.sections});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        itemCount: sections.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final section = sections[index];
          return InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                section.title,
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
