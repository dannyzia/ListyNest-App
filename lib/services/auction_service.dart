import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:listynest/models/ad_model.dart';

class AuctionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to place a new bid on an ad
  Future<void> placeBid(String adId, double bidAmount, String userId) async {
    final adRef = _firestore.collection('ads').doc(adId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(adRef);
      if (!snapshot.exists) {
        throw Exception("Ad does not exist!");
      }

      final ad = Ad.fromFirestore(snapshot);
      final auction = ad.auctionDetails;

      if (auction == null) {
        throw Exception("This is not an auction ad.");
      }

      if (DateTime.now().isAfter(auction.endTime)) {
        throw Exception("Auction has ended.");
      }

      if (bidAmount <= auction.currentBid) {
        throw Exception("Bid must be higher than the current bid.");
      }

      final newBid = Bid(
        userId: userId,
        amount: bidAmount,
        timestamp: DateTime.now(),
      );

      transaction.update(adRef, {
        'auctionDetails.currentBid': bidAmount,
        'auctionDetails.bids': FieldValue.arrayUnion([newBid.toJson()]),
      });
    });
  }

  // Function to get real-time stream of an ad for auction updates
  Stream<Ad> getAdStream(String adId) {
    return _firestore
        .collection('ads')
        .doc(adId)
        .snapshots()
        .map((snapshot) => Ad.fromFirestore(snapshot));
  }
}
