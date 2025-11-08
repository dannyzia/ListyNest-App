import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:listynest/providers/ad_provider.dart';
import 'package:listynest/widgets/ad_card.dart';

class MyAdsScreen extends StatefulWidget {
  const MyAdsScreen({super.key});

  @override
  _MyAdsScreenState createState() => _MyAdsScreenState();
}

class _MyAdsScreenState extends State<MyAdsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch user's ads when the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdProvider>(context, listen: false).fetchUserAds();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Ads'),
      ),
      body: Consumer<AdProvider>(
        builder: (context, adProvider, child) {
          if (adProvider.state == AdState.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (adProvider.state == AdState.error) {
            return Center(child: Text('Error: ${adProvider.errorMessage}'));
          }

          if (adProvider.userAds.isEmpty) {
            return const Center(
              child: Text('You have not created any ads yet.'),
            );
          }

          return ListView.builder(
            itemCount: adProvider.userAds.length,
            itemBuilder: (context, index) {
              final ad = adProvider.userAds[index];
              return AdCard(ad: ad);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/ad/new');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
