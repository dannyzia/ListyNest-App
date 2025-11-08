import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class AdService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> uploadAd(
    String title,
    String description,
    double price,
    List<XFile> images,
  ) async {
    final imageUrls = await _uploadImages(images);
    final user = _auth.currentUser;

    if (user != null) {
      await _firestore.collection('ads').add({
        'title': title,
        'description': description,
        'price': price,
        'imageUrls': imageUrls,
        'userId': user.uid,
      });
    }
  }

  Future<List<String>> _uploadImages(List<XFile> images) async {
    List<String> imageUrls = [];
    for (var image in images) {
      final ref = _storage.ref().child('ad_images/${DateTime.now().millisecondsSinceEpoch}');
      final uploadTask = ref.putFile(File(image.path));
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      imageUrls.add(downloadUrl);
    }
    return imageUrls;
  }

  Stream<QuerySnapshot> getAds() {
    return _firestore.collection('ads').snapshots();
  }

  Stream<QuerySnapshot> getAdsForUser(String userId) {
    return _firestore.collection('ads').where('userId', isEqualTo: userId).snapshots();
  }

  Future<DocumentSnapshot> getAdById(String adId) {
    return _firestore.collection('ads').doc(adId).get();
  }
}
