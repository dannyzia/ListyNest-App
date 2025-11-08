import 'package:flutter/material.dart';
import 'package:listynest/models/saved_search.dart';
import 'package:listynest/services/saved_search_service.dart';

class SavedSearchProvider with ChangeNotifier {
  final SavedSearchService _savedSearchService = SavedSearchService();
  List<SavedSearch> _savedSearches = [];

  List<SavedSearch> get savedSearches => _savedSearches;

  Future<void> loadSavedSearches() async {
    _savedSearches = await _savedSearchService.getSavedSearches();
    notifyListeners();
  }

  Future<void> saveSearch(SavedSearch search) async {
    await _savedSearchService.saveSearch(search);
    await loadSavedSearches();
  }

  Future<void> deleteSearch(String searchName) async {
    await _savedSearchService.deleteSearch(searchName);
    await loadSavedSearches();
  }
}
