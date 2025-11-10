import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/search_provider.dart';
import '../../widgets/ad_card.dart';
import '../profile/profile_screen.dart';
import '../my_ads/my_ads_screen.dart';
import '../profile/favorites_screen.dart';
import '../user/conversations_screen.dart';
import '../create_ad/create_ad_screen.dart';

class ListingsScreen extends StatefulWidget {
  const ListingsScreen({super.key});

  @override
  State<ListingsScreen> createState() => _ListingsScreenState();
}

class _ListingsScreenState extends State<ListingsScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SearchProvider>(context, listen: false).searchAds();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse Listings'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('My Profile'),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen())),
              ),
              PopupMenuItem(
                child: const Text('My Ads'),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MyAdsScreen())),
              ),
              PopupMenuItem(
                child: const Text('Favorites'),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoritesScreen())),
              ),
              PopupMenuItem(
                child: const Text('Messages'),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ConversationsScreen())),
              ),
              PopupMenuItem(
                child: const Text('Sign Out'),
                onTap: () => authProvider.logout(),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                final searchProvider = Provider.of<SearchProvider>(context, listen: false);
                searchProvider.setFilterOptions(searchProvider.filterOptions.copyWith(search: value));
              },
              decoration: InputDecoration(
                hintText: 'Search for listings...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          final searchProvider = Provider.of<SearchProvider>(context, listen: false);
                          searchProvider.setFilterOptions(searchProvider.filterOptions.copyWith(search: ''));
                        },
                      )
                    : null,
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: Consumer<SearchProvider>(
              builder: (context, searchProvider, child) {
                if (searchProvider.state == SearchState.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (searchProvider.state == SearchState.error) {
                  return Center(child: Text(searchProvider.errorMessage ?? 'An error occurred'));
                }

                final ads = searchProvider.ads;

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: ads.length,
                  itemBuilder: (context, index) {
                    final ad = ads[index];
                    return AdCard(ad: ad);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateAdScreen())),
        child: const Icon(Icons.add),
      ),
    );
  }
}
