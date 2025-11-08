import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:listynest/services/ad_service.dart';
import 'package:listynest/services/auth_service.dart';

class ListingsScreen extends StatefulWidget {
  @override
  _ListingsScreenState createState() => _ListingsScreenState();
}

class _ListingsScreenState extends State<ListingsScreen> {
  final AdService _adService = AdService();
  final AuthService _authService = AuthService();
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Browse Listings'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('My Profile'),
                onTap: () => context.go('/profile'),
              ),
              PopupMenuItem(
                child: Text('My Ads'),
                onTap: () => context.go('/my_ads'),
              ),
              PopupMenuItem(
                child: Text('Favorites'),
                onTap: () => context.go('/favorites'),
              ),
              PopupMenuItem(
                child: Text('Sign Out'),
                onTap: () async {
                  await _authService.signOut();
                },
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
              decoration: InputDecoration(
                hintText: 'Search for listings...',
                prefixIcon: Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _adService.getAds(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final ads = snapshot.data!.docs.where((ad) {
                  final title = ad['title'] as String;
                  return title.toLowerCase().contains(_searchQuery.toLowerCase());
                }).toList();

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: ads.length,
                  itemBuilder: (context, index) {
                    final ad = ads[index];
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/create_ad'),
        child: Icon(Icons.add),
      ),
    );
  }
}
