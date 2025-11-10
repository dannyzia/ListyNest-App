import 'dart:async';
// import 'api_service.dart'; // TODO: Use for backend integration

class LocationService {
  // TODO: Use _apiService when backend is ready
  // final ApiService _apiService = ApiService();

  Future<List<String>> getSuggestions(String query) async {
    // This is a mock implementation. Replace with actual API call.
    if (query.isEmpty) {
      return [];
    }
    return ['New York', 'Los Angeles', 'Chicago']
        .where((s) => s.toLowerCase().startsWith(query.toLowerCase()))
        .toList();
  }

  // Mock data for countries
  Future<List<String>> getCountries() async {
    return [
      'United States',
      'Canada',
      'United Kingdom',
      'Australia',
      'Germany',
      'France',
      'Spain',
      'Italy',
      'Japan',
      'China',
      'India',
      'Brazil',
      'Mexico',
    ];
  }

  // Mock data for states
  Future<List<String>> getStates(String country) async {
    if (country == 'United States') {
      return [
        'California',
        'New York',
        'Texas',
        'Florida',
        'Illinois',
        'Pennsylvania',
        'Ohio',
        'Georgia',
        'North Carolina',
        'Michigan',
      ];
    }
    // Return empty list for other countries in MVP
    return [];
  }

  // Mock data for cities
  Future<List<String>> getCities(String country, String state) async {
    if (country == 'United States' && state == 'California') {
      return [
        'Los Angeles',
        'San Francisco',
        'San Diego',
        'San Jose',
        'Sacramento',
        'Fresno',
        'Long Beach',
        'Oakland',
      ];
    }
    // Return empty list for other combinations in MVP
    return [];
  }
}
