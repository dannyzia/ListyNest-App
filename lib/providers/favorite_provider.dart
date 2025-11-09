import 'package:flutter/foundation.dart';
import '../models/ad.dart';
import '../services/ad_service.dart';

class FavoriteProvider with ChangeNotifier {
  final AdService _adService = AdService();
  List<Ad> _favorites = [];
  bool _isLoading = false;
  
  List<Ad> get favorites => _favorites;
  bool get isLoading => _isLoading;
  
  Future<void> loadFavorites(String userId) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _favorites = await _adService.fetchFavorites(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> toggleFavorite(String adId, String userId) async {
    try {
      await _adService.toggleFavorite(adId, userId);
      await loadFavorites(userId);
    } catch (e) {
      rethrow;
    }
  }
  
  bool isFavorite(String adId) {
    return _favorites.any((ad) => ad.id == adId);
  }
}
