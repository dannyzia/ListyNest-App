import 'package:flutter/material.dart';
import 'widgets/search_bar.dart';
import 'widgets/filter_options.dart';
import 'widgets/search_results.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Column(
        children: [
          SearchBar(),
          FilterOptions(),
          SearchResults(),
        ],
      ),
    );
  }
}
