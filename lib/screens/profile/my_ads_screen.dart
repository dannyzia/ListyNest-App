import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/ad_provider.dart';
import '../../widgets/ad_card.dart';

class MyAdsScreen extends StatelessWidget {
  const MyAdsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Ads'),
      ),
      body: Consumer<AdProvider>(
        builder: (context, adProvider, child) {
          // This is a placeholder. You need to implement a way to fetch
          // ads belonging to the current user.
          final myAds = adProvider.ads;

          if (myAds.isEmpty) {
            return const Center(child: Text('You have not posted any ads yet.'));
          }

          return ListView.builder(
            itemCount: myAds.length,
            itemBuilder: (context, index) {
              return AdCard(ad: myAds[index]);
            },
          );
        },
      ),
    );
  }
}
