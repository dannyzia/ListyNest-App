import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addFavorite(String adId) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('favorites').add({
        'adId': adId,
        'userId': user.uid,
      });
    }
  }

  Future<void> removeFavorite(String adId) async {
    final user = _auth.currentUser;
    if (user != null) {
      final querySnapshot = await _firestore
          .collection('favorites')
          .where('adId', isEqualTo: adId)
          .where('userId', isEqualTo: user.uid)
          .get();
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    }
  }

  Stream<QuerySnapshot> getFavorites() {
    final user = _auth.currentUser;
    if (user != null) {
      return _firestore.collection('favorites').where('userId', isEqualTo: user.uid).snapshots();
    }
    return const Stream.empty();
  }

  Stream<bool> isFavorite(String adId) {
    final user = _auth.currentUser;
    if (user != null) {
      return _firestore
          .collection('favorites')
          .where('adId', isEqualTo: adId)
          .where('userId', isEqualTo: user.uid)
          .snapshots()
          .map((snapshot) => snapshot.docs.isNotEmpty);
    }
    return Stream.value(false);
  }
}
