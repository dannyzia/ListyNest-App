import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:listynest/providers/saved_search_provider.dart';

class SavedSearchesScreen extends StatefulWidget {
  const SavedSearchesScreen({super.key});

  @override
  _SavedSearchesScreenState createState() => _SavedSearchesScreenState();
}

class _SavedSearchesScreenState extends State<SavedSearchesScreen> {
  @override
  void initState() {
    super.initState();
    // Load saved searches when the screen is initialized
    Provider.of<SavedSearchProvider>(context, listen: false).loadSavedSearches();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Searches'),
      ),
      body: Consumer<SavedSearchProvider>(
        builder: (context, provider, child) {
          if (provider.savedSearches.isEmpty) {
            return const Center(
              child: Text('You have no saved searches.'),
            );
          }

          return ListView.builder(
            itemCount: provider.savedSearches.length,
            itemBuilder: (context, index) {
              final search = provider.savedSearches[index];
              return ListTile(
                title: Text(search.name),
                subtitle: Text(search.searchTerm),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    provider.deleteSearch(search.name);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Search deleted.')),
                    );
                  },
                ),
                onTap: () {
                  // Navigate back to the search screen and apply the saved search.
                  // This part requires a bit more logic to pass the search parameters back to the search screen.
                  // For now, we'll just pop the screen.
                  Navigator.of(context).pop();
                },
              );
            },
          );
        },
      ),
    );
  }
}
