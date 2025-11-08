import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:listynest/services/ad_service.dart';
import 'package:listynest/services/favorite_service.dart';

class FavoritesScreen extends StatelessWidget {
  final FavoriteService _favoriteService = FavoriteService();
  final AdService _adService = AdService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _favoriteService.getFavorites(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text('You have no favorite ads yet.'));
          }

          final favoriteAdIds = snapshot.data!.docs.map((doc) => doc['adId'] as String).toList();

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
            ),
            itemCount: favoriteAdIds.length,
            itemBuilder: (context, index) {
              return FutureBuilder<DocumentSnapshot>(
                future: _adService.getAdById(favoriteAdIds[index]),
                builder: (context, adSnapshot) {
                  if (adSnapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (adSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!adSnapshot.hasData || !adSnapshot.data!.exists) {
                    return Container(); // Handle deleted ad case
                  }

                  final ad = adSnapshot.data!;
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
          );
        },
      ),
    );
  }
}
