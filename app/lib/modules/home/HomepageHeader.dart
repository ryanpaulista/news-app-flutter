import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomepageHeader extends StatelessWidget {
  const HomepageHeader({super.key});

  @override
  Widget build(BuildContext context){
    return Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black12, width: 1))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("NewsHub", style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight(700))),
            Row(
              spacing: 1,
              children: [
                const IconButton(icon: Icon(Icons.search), tooltip: "Search", onPressed: null, iconSize: 32,),
                const IconButton(icon: Icon(Icons.bookmark_border_outlined), tooltip: "Favorites", onPressed: null, iconSize: 32,)
              ],
            )
          ],
        )
    );
  }
}