
import 'package:flutter/foundation.dart';
import '../services/location_service.dart';

class LocationProvider with ChangeNotifier {
  final LocationService _locationService;

  LocationProvider(this._locationService);

  List<String> _countries = [];
  List<String> get countries => _countries;

  List<String> _states = [];
  List<String> get states => _states;

  List<String> _cities = [];
  List<String> get cities => _cities;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _selectedCountry;
  String? get selectedCountry => _selectedCountry;

  String? _selectedState;
  String? get selectedState => _selectedState;

  String? _selectedCity;
  String? get selectedCity => _selectedCity;

  Future<void> fetchCountries() async {
    _isLoading = true;
    notifyListeners();
    try {
      _countries = await _locationService.getCountries();
    } catch (e) {
      // Handle error
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchStates(String country) async {
    _isLoading = true;
    _selectedCountry = country;
    _states = [];
    _cities = [];
    notifyListeners();
    try {
      _states = await _locationService.getStates(country);
    } catch (e) {
      // Handle error
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchCities(String state) async {
    _isLoading = true;
    _selectedState = state;
    _cities = [];
    notifyListeners();
    try {
      _cities = await _locationService.getCities(state);
    } catch (e) {
      // Handle error
    }
    _isLoading = false;
    notifyListeners();
  }

  void setCity(String city) {
    _selectedCity = city;
    notifyListeners();
  }
}
