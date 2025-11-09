import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/ad.dart';
import '../services/ad_service.dart';

class AdProvider with ChangeNotifier {
  final AdService adService;
  
  AdProvider({required this.adService});

  List<Ad> _ads = [];
  Ad? _selectedAd;
  bool _isLoading = false;
  String? _errorMessage;
  
  List<Ad> get ads => _ads;
  Ad? get selectedAd => _selectedAd;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  // ✅ Fetch all ads
  Future<void> fetchAds({
    String? category,
    String? search,
    double? minPrice,
    double? maxPrice,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      _ads = await adService.fetchAds(
        category: category,
        search: search,
        minPrice: minPrice,
        maxPrice: maxPrice,
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // ✅ Fetch ad by ID
  Future<void> fetchAdById(String id) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _selectedAd = await adService.getAdById(id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // ✅ Create a new ad with image uploads
Future<void> createAd(Ad ad, List<XFile> images) async {
  _isLoading = true;
  _errorMessage = null;
  notifyListeners();

  try {
    List<String> imageUrls = [];
    for (var image in images) {
      final ref = FirebaseStorage.instance.ref('ads/${DateTime.now().toIso8601String()}');
      final uploadTask = ref.putFile(File(image.path));
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      imageUrls.add(downloadUrl);
    }

    final newAd = ad.copyWith(imageUrls: imageUrls);
    await adService.createAd(newAd);
    await fetchAds(); // Refresh the list of ads

    _isLoading = false;
    notifyListeners();
  } catch (e) {
    _errorMessage = e.toString();
    _isLoading = false;
    notifyListeners();
    rethrow; // Rethrow the exception to be caught in the UI
  }
}

  // ✅ Fetch user's ads
  Future<void> fetchUserAds(String userId) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _ads = await adService.fetchUserAds(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // ✅ Fetch favorites
  Future<void> fetchFavorites(String userId) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _ads = await adService.fetchFavorites(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // ✅ Toggle favorite
  Future<void> toggleFavorite(String adId, String userId) async {
    try {
      await adService.toggleFavorite(adId, userId);
      await fetchAds(); // Refresh
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // ✅ Report ad
  Future<void> reportAd(String adId, String reason) async {
    try {
      await adService.reportAd(adId, reason);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}
