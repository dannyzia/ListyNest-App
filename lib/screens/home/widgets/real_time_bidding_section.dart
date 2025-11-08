import 'dart:async';
import 'package:flutter/material.dart';
import 'package:listynest/services/bidding_service.dart';
import 'package:listynest/screens/home/widgets/real_time_bidding_card.dart';

class RealTimeBiddingSection extends StatefulWidget {
  @override
  _RealTimeBiddingSectionState createState() => _RealTimeBiddingSectionState();
}

class _RealTimeBiddingSectionState extends State<RealTimeBiddingSection> {
  final BiddingService _biddingService = BiddingService();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<Bid> _bids = [];

  @override
  void initState() {
    super.initState();
    _biddingService.bidStream.listen((bid) {
      if (mounted) {
        _addBid(bid);
      }
    });
  }

  void _addBid(Bid bid) {
    _bids.insert(0, bid);
    _listKey.currentState?.insertItem(0, duration: Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Real-time Bidding',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        SizedBox(
          height: 250,
          child: AnimatedList(
            key: _listKey,
            initialItemCount: _bids.length,
            itemBuilder: (context, index, animation) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(-1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: RealTimeBiddingCard(bid: _bids[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _biddingService.dispose();
    super.dispose();
  }
}
