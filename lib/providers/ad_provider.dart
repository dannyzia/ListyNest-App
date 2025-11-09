import 'package:flutter/foundation.dart';
import '../models/ad.dart';
import '../services/ad_service.dart';

class AdProvider with ChangeNotifier {
  final AdService _adService = AdService();
  List<Ad> _ads = [];
  bool _isLoading = false;
  String? _errorMessage;
  
  List<Ad> get ads => _ads;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  Future<void> fetchAds() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      _ads = await _adService.fetchAds();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> postAd(Ad ad) async {
    try {
      await _adService.createAd(ad);
      await fetchAds();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}