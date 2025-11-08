import 'package:flutter/foundation.dart';

class FilterProvider with ChangeNotifier {
  String? _category;
  String? _location;
  double? _minPrice;
  double? _maxPrice;
  String? _searchQuery;

  String? get category => _category;
  String? get location => _location;
  double? get minPrice => _minPrice;
  double? get maxPrice => _maxPrice;
  String? get searchQuery => _searchQuery;

  void setCategory(String? category) {
    _category = category;
    notifyListeners();
  }

  void setLocation(String? location) {
    _location = location;
    notifyListeners();
  }

  void setPriceRange(double? min, double? max) {
    _minPrice = min;
    _maxPrice = max;
    notifyListeners();
  }

  void setSearchQuery(String? query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearFilters() {
    _category = null;
    _location = null;
    _minPrice = null;
    _maxPrice = null;
    _searchQuery = null;
    notifyListeners();
  }
}
