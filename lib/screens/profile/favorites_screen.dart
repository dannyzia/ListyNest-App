import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/ad_provider.dart';
import '../../widgets/ad_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: Consumer<AdProvider>(
        builder: (context, adProvider, child) {
          // This is a placeholder. You need to implement a way to fetch
          // the user's favorite ads.
          final favoriteAds = adProvider.ads.where((ad) => ad.isFavorite).toList();

          if (favoriteAds.isEmpty) {
            return const Center(child: Text('You have no favorite ads yet.'));
          }

          return ListView.builder(
            itemCount: favoriteAds.length,
            itemBuilder: (context, index) {
              return AdCard(ad: favoriteAds[index]);
            },
          );
        },
      ),
    );
  }
}
