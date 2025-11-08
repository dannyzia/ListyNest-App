
import 'api_service.dart';

class LocationService {
  final ApiService _apiService;

  LocationService(this._apiService);

  Future<List<String>> getCountries() async {
    try {
      final response = await _apiService.get('/locations/countries');
      return List<String>.from(response.data['countries']);
    } catch (e) {
      throw Exception('Failed to fetch countries: ${e.toString()}');
    }
  }

  Future<List<String>> getStates(String country) async {
    try {
      final response = await _apiService.get('/locations/states/$country');
      return List<String>.from(response.data['states']);
    } catch (e) {
      throw Exception('Failed to fetch states: ${e.toString()}');
    }
  }

  Future<List<String>> getCities(String state) async {
    try {
      final response = await _apiService.get('/locations/cities/$state');
      return List<String>.from(response.data['cities']);
    } catch (e) {
      throw Exception('Failed to fetch cities: ${e.toString()}');
    }
  }
}
