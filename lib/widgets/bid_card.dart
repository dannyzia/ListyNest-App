import 'package:flutter/material.dart';
import '../models/bid_model.dart';

class BidCard extends StatelessWidget {
  final Bid bid;

  const BidCard({super.key, required this.bid});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('Bid by ${bid.userId}'),
        subtitle: Text('\$${bid.amount}'),
      ),
    );
  }
}
