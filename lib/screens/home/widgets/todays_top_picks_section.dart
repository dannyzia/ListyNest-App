import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import './top_pick_card.dart';

class TodaysTopPicksSection extends StatelessWidget {
  const TodaysTopPicksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Today\'s Top Picks',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(), // To disable scrolling within the ListView
          itemCount: 5, // Replace with actual top picks count
          itemBuilder: (context, index) {
            return TopPickCard();
          },
        ),
        Center(
          child: ElevatedButton(
            onPressed: () => context.go('/listings'),
            child: Text('Browse All'),
          ),
        ),
      ],
    );
  }
}
