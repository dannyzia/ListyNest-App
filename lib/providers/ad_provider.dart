import 'package:flutter/foundation.dart';
import '../models/ad_model.dart';
import '../services/ad_service.dart';

class AdProvider with ChangeNotifier {
  final AdService _adService;

  List<Ad> _ads = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Ad> get ads => _ads;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AdProvider(this._adService);

  Future<void> fetchAds({String? category, String? location, double? minPrice, double? maxPrice, String? search}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _ads = await _adService.getAds(category: category, location: location, minPrice: minPrice, maxPrice: maxPrice, search: search);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createAd(Map<String, dynamic> adData) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _adService.createAd(adData);
      await fetchAds(); // Refresh the list
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Add other methods for updating, deleting, and favoriting ads
}
