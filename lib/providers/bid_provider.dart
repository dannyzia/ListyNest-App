import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/bid.dart';

class BidProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Bid> _bids = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Bid> get bids => _bids;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchBids(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final bidsSnapshot = await _firestore
          .collection('bids')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();

      _bids = bidsSnapshot.docs
          .map((doc) => Bid.fromMap(doc.data(), doc.id))
          .toList();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
