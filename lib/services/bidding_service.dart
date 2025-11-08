import 'dart:async';
import 'dart:math';

class Bid {
  final String adId;
  final double amount;
  final String bidder;

  Bid({required this.adId, required this.amount, required this.bidder});
}

class BiddingService {
  final _bidController = StreamController<Bid>.broadcast();
  Stream<Bid> get bidStream => _bidController.stream;

  BiddingService() {
    // Simulate real-time bidding data
    Timer.periodic(Duration(seconds: 2), (timer) {
      final random = Random();
      final bid = Bid(
        adId: 'ad${random.nextInt(5)}',
        amount: random.nextDouble() * 100,
        bidder: 'User${random.nextInt(100)}',
      );
      _bidController.add(bid);
    });
  }

  void dispose() {
    _bidController.close();
  }
}
