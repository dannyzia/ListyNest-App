import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:listynest/services/ad_service.dart';

class MyAdsScreen extends StatelessWidget {
  final AdService _adService = AdService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Ads'),
      ),
      body: user == null
          ? Center(child: Text('Please log in to see your ads.'))
          : StreamBuilder<QuerySnapshot>(
              stream: _adService.getAdsForUser(user.uid),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('You have not created any ads yet.'));
                }

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final ad = snapshot.data!.docs[index];
                    return InkWell(
                      onTap: () => context.go('/ad/${ad.id}'),
                      child: Card(
                        child: Column(
                          children: [
                            if (ad['imageUrls'] != null && ad['imageUrls'].isNotEmpty)
                              Image.network(ad['imageUrls'][0], height: 100, fit: BoxFit.cover),
                            Text(ad['title']),
                            Text('\$${ad['price']}'),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
