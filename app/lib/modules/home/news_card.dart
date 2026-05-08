import 'package:flutter/material.dart';

class NewsCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String author;
  final String postedAt;

  const NewsCard({super.key, required this.title, required this.author, required this.postedAt, required this.imageUrl});

  @override
  Widget build(BuildContext context){
    return Container(
        height: 200,
        decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 10,
          children:
          [
            Expanded(
              child: imageUrl.isEmpty ? Container(decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)))) : Image.network(imageUrl),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Text(title),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("$author - $postedAt"),
                      Icon(Icons.bookmark_add_outlined, color: Colors.grey, size: 20,)
                    ],
                  )
                ],
              ),
            )
          ],
        ),
    );
  }
}