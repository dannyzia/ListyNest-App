import 'package:flutter/foundation.dart';
import 'package:listynest/models/ad_model.dart';
import 'package:listynest/models/filter_options.dart';
import 'package:listynest/services/ad_service.dart';

enum SearchState {
  initial,
  loading,
  loaded,
  error,
}

class SearchProvider with ChangeNotifier {
  final AdService adService;

  SearchProvider({required this.adService});

  SearchState _state = SearchState.initial;
  SearchState get state => _state;

  List<Ad> _ads = [];
  List<Ad> get ads => _ads;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  FilterOptions _filterOptions = FilterOptions();
  FilterOptions get filterOptions => _filterOptions;

  void setFilterOptions(FilterOptions options) {
    _filterOptions = options;
    notifyListeners();
  }

  Future<void> searchAds() async {
    _state = SearchState.loading;
    notifyListeners();

    try {
      _ads = await adService.fetchAds(
        search: _filterOptions.search,
        category: _filterOptions.category,
        location: _filterOptions.location,
        minPrice: _filterOptions.minPrice,
        maxPrice: _filterOptions.maxPrice,
      );
      _state = SearchState.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _state = SearchState.error;
    }
    notifyListeners();
  }
}
