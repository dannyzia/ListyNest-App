
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ad_provider.dart';
import '../widgets/ad_card.dart';

class SearchResultsScreen extends StatefulWidget {
  final String query;

  const SearchResultsScreen({super.key, required this.query});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<AdProvider>(context, listen: false).searchAds(widget.query));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results for "${widget.query}"'),
      ),
      body: Consumer<AdProvider>(
        builder: (context, adProvider, child) {
          if (adProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (adProvider.errorMessage != null) {
            return Center(child: Text('Error: ${adProvider.errorMessage}'));
          }

          if (adProvider.searchedAds.isEmpty) {
            return const Center(child: Text('No ads found.'));
          }

          return ListView.builder(
            itemCount: adProvider.searchedAds.length,
            itemBuilder: (context, index) {
              final ad = adProvider.searchedAds[index];
              return AdCard(ad: ad);
            },
          );
        },
      ),
    );
  }
}
