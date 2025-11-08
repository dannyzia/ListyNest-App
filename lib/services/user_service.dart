
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:listynest/models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _usersCollection = 'users';

  // Create a new user document in Firestore
  Future<void> createUser(UserModel user) async {
    try {
      await _firestore.collection(_usersCollection).doc(user.uid).set(user.toMap());
    } catch (e) {
      print('Error creating user: $e');
    }
  }

  // Get a user document from Firestore by UID
  Future<UserModel?> getUser(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection(_usersCollection).doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  // Update a user document in Firestore
  Future<void> updateUser(UserModel user) async {
    try {
      await _firestore.collection(_usersCollection).doc(user.uid).update(user.toMap());
    } catch (e) {
      print('Error updating user: $e');
    }
  }
}
