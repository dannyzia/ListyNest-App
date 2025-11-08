import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:listynest/models/feedback.dart';

class FeedbackService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> submitFeedback(String adId, String feedback) async {
    final user = _auth.currentUser;
    if (user != null) {
      final newFeedback = Feedback(
        adId: adId,
        userId: user.uid,
        feedback: feedback,
      );
      await _firestore.collection('feedback').add(newFeedback.toJson());
    }
  }
}
