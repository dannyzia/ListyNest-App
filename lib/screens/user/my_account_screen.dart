import 'package:flutter/material.dart';
import 'package:listynest/screens/my_ads/my_ads_screen.dart';
import 'package:listynest/screens/profile/favorites_screen.dart';
import 'package:listynest/screens/my_bids/my_bids_screen.dart';

class MyAccountScreen extends StatelessWidget {
  const MyAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('My Ads'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const MyAdsScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('My Favorites'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoritesScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.gavel),
            title: const Text('My Bids'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const MyBidsScreen()));
            },
          ),
        ],
      ),
    );
  }
}
