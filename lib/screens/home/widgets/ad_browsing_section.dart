import 'package:flutter/material.dart';
import './ad_card.dart';

class AdBrowsingSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10, // Replace with actual ad count
        itemBuilder: (context, index) {
          return AdCard();
        },
      ),
    );
  }
}
