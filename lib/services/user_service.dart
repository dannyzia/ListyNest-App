
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _usersCollection = 'users';

  // Create a new user document in Firestore
  Future<void> createUser(String uid, String email, {String? displayName, String? photoURL}) async {
    try {
      await _firestore.collection(_usersCollection).doc(uid).set({
        'uid': uid,
        'email': email,
        'displayName': displayName ?? email.split('@')[0],
        'photoURL': photoURL,
        'createdAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      // Use debugPrint instead of print
      throw Exception('Error creating user: $e');
    }
  }

  // Get a user document from Firestore by UID
  Future<Map<String, dynamic>?> getUser(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection(_usersCollection).doc(uid).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      throw Exception('Error getting user: $e');
    }
  }

  // Update a user document in Firestore
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(_usersCollection).doc(uid).update(data);
    } catch (e) {
      throw Exception('Error updating user: $e');
    }
  }
}
