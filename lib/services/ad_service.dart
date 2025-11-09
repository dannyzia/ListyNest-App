
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ad.dart';

class AdService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ✅ Fetch ads with filters
  Future<List<Ad>> fetchAds({
    String? category,
    String? search,
    double? minPrice,
    double? maxPrice,
  }) async {
    try {
      Query query = _firestore.collection('ads');

      if (category != null && category.isNotEmpty) {
        query = query.where('category', isEqualTo: category);
      }
      
      if (minPrice != null) {
        query = query.where('price', isGreaterThanOrEqualTo: minPrice);
      }
      
      if (maxPrice != null) {
        query = query.where('price', isLessThanOrEqualTo: maxPrice);
      }

      final snapshot = await query.get();
      
      List<Ad> ads = snapshot.docs
          .map((doc) => Ad.fromFirestore(doc))
          .toList();

      // Apply search filter in-memory if provided
      if (search != null && search.isNotEmpty) {
        ads = ads.where((ad) => 
          ad.title.toLowerCase().contains(search.toLowerCase()) ||
          ad.description.toLowerCase().contains(search.toLowerCase())
        ).toList();
      }

      return ads;
    } catch (e) {
      throw Exception('Failed to fetch ads: $e');
    }
  }

  // ✅ Get single ad by ID
  Future<Ad?> getAdById(String id) async {
    try {
      final doc = await _firestore.collection('ads').doc(id).get();
      if (!doc.exists) return null;
      return Ad.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to fetch ad: $e');
    }
  }

  // ✅ Create new ad
  Future<void> createAd(Ad ad) async {
    try {
      await _firestore.collection('ads').add(ad.toJson());
    } catch (e) {
      throw Exception('Failed to create ad: $e');
    }
  }

  // ✅ Update ad
  Future<void> updateAd(String id, Ad ad) async {
    try {
      await _firestore.collection('ads').doc(id).update(ad.toJson());
    } catch (e) {
      throw Exception('Failed to update ad: $e');
    }
  }

  // ✅ Delete ad
  Future<void> deleteAd(String id) async {
    try {
      await _firestore.collection('ads').doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete ad: $e');
    }
  }

  // ✅ Get user's ads
  Future<List<Ad>> fetchUserAds(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('ads')
          .where('userId', isEqualTo: userId)
          .get();
      
      return snapshot.docs.map((doc) => Ad.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to fetch user ads: $e');
    }
  }

  // ✅ Toggle favorite
  Future<void> toggleFavorite(String adId, String userId) async {
    try {
      final docRef = _firestore.collection('ads').doc(adId);
      final doc = await docRef.get();
      
      if (!doc.exists) return;
      
      List<String> favoritedBy = List<String>.from(doc.data()?['favoritedBy'] ?? []);
      
      if (favoritedBy.contains(userId)) {
        favoritedBy.remove(userId);
      } else {
        favoritedBy.add(userId);
      }
      
      await docRef.update({'favoritedBy': favoritedBy});
    } catch (e) {
      throw Exception('Failed to toggle favorite: $e');
    }
  }

  // ✅ Get favorite ads
  Future<List<Ad>> fetchFavorites(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('ads')
          .where('favoritedBy', arrayContains: userId)
          .get();
      
      return snapshot.docs.map((doc) => Ad.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to fetch favorites: $e');
    }
  }

  // ✅ Report ad
  Future<void> reportAd(String adId, String reason) async {
    try {
      await _firestore.collection('reports').add({
        'adId': adId,
        'reason': reason,
        'reportedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to report ad: $e');
    }
  }
}
