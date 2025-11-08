import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/ad_provider.dart';
import '../../widgets/ad_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    final query = _searchController.text;
    if (query.isNotEmpty) {
      Provider.of<AdProvider>(context, listen: false).fetchAds(search: query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search ads...',
            border: InputBorder.none,
          ),
          onSubmitted: (_) => _performSearch(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _performSearch,
          ),
        ],
      ),
      body: Consumer<AdProvider>(
        builder: (context, adProvider, child) {
          if (adProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (adProvider.errorMessage != null) {
            return Center(child: Text(adProvider.errorMessage!));
          }
          if (adProvider.ads.isEmpty) {
            return const Center(child: Text('No ads found.'));
          }
          return ListView.builder(
            itemCount: adProvider.ads.length,
            itemBuilder: (context, index) {
              return AdCard(ad: adProvider.ads[index]);
            },
          );
        },
      ),
    );
  }
}
