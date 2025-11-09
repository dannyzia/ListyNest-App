import 'dart:async';
import 'api_service.dart';

class LocationService {
  final ApiService _apiService = ApiService();

  Future<List<String>> getSuggestions(String query) async {
    // This is a mock implementation. Replace with actual API call.
    if (query.isEmpty) {
      return [];
    }
    return ['New York', 'Los Angeles', 'Chicago']
        .where((s) => s.toLowerCase().startsWith(query.toLowerCase()))
        .toList();
  }
}
