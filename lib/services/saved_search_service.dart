import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:listynest/models/saved_search.dart';
import 'package:listynest/models/filter_options.dart';

class SavedSearchService {
  static const String _savedSearchesKey = 'saved_searches';

  Future<void> saveSearch(SavedSearch search) async {
    final prefs = await SharedPreferences.getInstance();
    final savedSearches = await getSavedSearches();
    
    // Remove existing search with the same name to avoid duplicates
    savedSearches.removeWhere((s) => s.name == search.name);
    savedSearches.add(search);
    
    final List<String> searchesJson = savedSearches.map((s) => json.encode({
      'name': s.name,
      'searchTerm': s.searchTerm,
      'filterOptions': {
        'search': s.filterOptions.search,
        'condition': s.filterOptions.condition,
        'datePosted': s.filterOptions.datePosted,
        'minPrice': s.filterOptions.minPrice,
        'maxPrice': s.filterOptions.maxPrice,
        'category': s.filterOptions.category?.name,
        'location': s.filterOptions.location,
      }
    })).toList();
    
    await prefs.setStringList(_savedSearchesKey, searchesJson);
  }

  Future<List<SavedSearch>> getSavedSearches() async {
    final prefs = await SharedPreferences.getInstance();
    final searchesJson = prefs.getStringList(_savedSearchesKey) ?? [];
    
    return searchesJson.map((s) {
      final Map<String, dynamic> searchMap = json.decode(s);
      final filterOptionsMap = searchMap['filterOptions'] as Map<String, dynamic>;
      
      return SavedSearch(
        name: searchMap['name'],
        searchTerm: searchMap['searchTerm'],
        filterOptions: FilterOptions(
          search: filterOptionsMap['search'],
          condition: filterOptionsMap['condition'],
          datePosted: filterOptionsMap['datePosted'],
          minPrice: filterOptionsMap['minPrice']?.toDouble(),
          maxPrice: filterOptionsMap['maxPrice']?.toDouble(),
          location: filterOptionsMap['location'],
          // Note: Category object is not fully reconstructed here.
          // This is a limitation of this implementation.
        ),
      );
    }).toList();
  }

  Future<void> deleteSearch(String searchName) async {
    final prefs = await SharedPreferences.getInstance();
    final savedSearches = await getSavedSearches();
    savedSearches.removeWhere((s) => s.name == searchName);
    
    final List<String> searchesJson = savedSearches.map((s) => json.encode({
      'name': s.name,
      'searchTerm': s.searchTerm,
      'filterOptions': {
        'search': s.filterOptions.search,
        'condition': s.filterOptions.condition,
        'datePosted': s.filterOptions.datePosted,
        'minPrice': s.filterOptions.minPrice,
        'maxPrice': s.filterOptions.maxPrice,
        'category': s.filterOptions.category?.name,
        'location': s.filterOptions.location,
      }
    })).toList();
    
    await prefs.setStringList(_savedSearchesKey, searchesJson);
  }
}
