import 'package:flutter/material.dart';
import '../models/auction_model.dart';

class AuctionCard extends StatelessWidget {
  final Auction auction;

  const AuctionCard({super.key, required this.auction});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.network(auction.images[0]),
          Text(auction.title),
          Text('\$${auction.startingPrice}'),
        ],
      ),
    );
  }
}
