import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:listynest/models/user_profile.dart';

class UserProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<UserProfile> getUserProfile() {
    final user = _auth.currentUser;
    if (user != null) {
      return _firestore.collection('users').doc(user.uid).snapshots().map(
            (snapshot) => UserProfile.fromMap(snapshot.data() as Map<String, dynamic>, user.uid),
          );
    }
    return Stream.empty();
  }

  Future<void> updateUserProfile(UserProfile userProfile) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set(userProfile.toMap());
    }
  }
}
