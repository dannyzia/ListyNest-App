// lib/screens/user/my_ads_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/ad_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/ad_card.dart';

class MyAdsScreen extends StatefulWidget {
  const MyAdsScreen({super.key});

  @override
  State<MyAdsScreen> createState() => _MyAdsScreenState();
}

class _MyAdsScreenState extends State<MyAdsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      if (authProvider.user != null) {
        context.read<AdProvider>().fetchUserAds(authProvider.user!.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final adProvider = context.watch<AdProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Ads'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final authProvider = context.read<AuthProvider>();
          if (authProvider.user != null) {
            await adProvider.fetchUserAds(authProvider.user!.uid);
          }
        },
        child: adProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : adProvider.ads.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.inbox, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        const Text('No ads yet', style: TextStyle(fontSize: 18)),
                        const SizedBox(height: 8),
                        const Text(
                          'Start by posting your first ad',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => Navigator.pushNamed(context, '/post-ad'),
                          child: const Text('Post Ad'),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: adProvider.ads.length,
                    itemBuilder: (context, index) {
                      return AdCard(ad: adProvider.ads[index]);
                    },
                  ),
      ),
    );
  }
}
