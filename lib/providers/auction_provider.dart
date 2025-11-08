import 'dart:async';
import 'package:flutter/material.dart';
import 'package:listynest/models/ad_model.dart';
import 'package:listynest/services/auction_service.dart';

class AuctionProvider with ChangeNotifier {
  final AuctionService _auctionService = AuctionService();
  StreamSubscription<Ad>? _adStreamSubscription;
  Ad? _currentAd;

  Ad? get currentAd => _currentAd;

  void listenToAd(String adId) {
    _adStreamSubscription?.cancel();
    _adStreamSubscription = _auctionService.getAdStream(adId).listen((ad) {
      _currentAd = ad;
      notifyListeners();
    });
  }

  Future<void> placeBid(String adId, double bidAmount, String userId) async {
    try {
      await _auctionService.placeBid(adId, bidAmount, userId);
    } catch (e) {
      // Handle error, maybe show a snackbar
      print(e); // For now, just print the error
    }
  }

  @override
  void dispose() {
    _adStreamSubscription?.cancel();
    super.dispose();
  }
}
