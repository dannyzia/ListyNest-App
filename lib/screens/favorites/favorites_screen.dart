// lib/screens/favorites/favorites_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/favorite_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/ad_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      if (authProvider.user != null) {
        context.read<FavoriteProvider>().loadFavorites(authProvider.user!.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = context.watch<FavoriteProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final authProvider = context.read<AuthProvider>();
          if (authProvider.user != null) {
            await favoriteProvider.loadFavorites(authProvider.user!.uid);
          }
        },
        child: favoriteProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : favoriteProvider.favorites.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('No favorites yet', style: TextStyle(fontSize: 18)),
                        SizedBox(height: 8),
                        Text(
                          'Save ads you like to view them later',
                          style: TextStyle(color: Colors.grey),
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
                    itemCount: favoriteProvider.favorites.length,
                    itemBuilder: (context, index) {
                      return AdCard(ad: favoriteProvider.favorites[index]);
                    },
                  ),
      ),
    );
  }
}
