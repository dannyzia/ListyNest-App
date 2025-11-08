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
        'sortBy': s.filterOptions.sortBy,
        'condition': s.filterOptions.condition,
        'datePosted': s.filterOptions.datePosted,
        'priceRange': s.filterOptions.priceRange != null ? {'start': s.filterOptions.priceRange!.start, 'end': s.filterOptions.priceRange!.end} : null,
        'category': s.filterOptions.category?.name,
        'country': s.filterOptions.country?.name,
        'state': s.filterOptions.state?.name,
        'city': s.filterOptions.city?.name,
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
          sortBy: filterOptionsMap['sortBy'],
          condition: filterOptionsMap['condition'],
          datePosted: filterOptionsMap['datePosted'],
          priceRange: filterOptionsMap['priceRange'] != null ? RangeValues(filterOptionsMap['priceRange']['start'], filterOptionsMap['priceRange']['end']) : null,
          // Note: Category, Country, State, and City objects are not fully reconstructed here.
          // This is a limitation of this implementation. For a full implementation, you would need to fetch these objects from their respective providers based on the stored names.
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
        'sortBy': s.filterOptions.sortBy,
        'condition': s.filterOptions.condition,
        'datePosted': s.filterOptions.datePosted,
        'priceRange': s.filterOptions.priceRange != null ? {'start': s.filterOptions.priceRange!.start, 'end': s.filterOptions.priceRange!.end} : null,
        'category': s.filterOptions.category?.name,
        'country': s.filterOptions.country?.name,
        'state': s.filterOptions.state?.name,
        'city': s.filterOptions.city?.name,
      }
    })).toList();
    
    await prefs.setStringList(_savedSearchesKey, searchesJson);
  }
}
