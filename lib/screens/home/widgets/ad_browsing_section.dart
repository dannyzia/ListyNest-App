import 'package:flutter/material.dart';
import './ad_card.dart';

class AdBrowsingSection extends StatelessWidget {
  const AdBrowsingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
