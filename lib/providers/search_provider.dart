
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:listynest/models/ad.dart';
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
  StreamSubscription<List<Ad>>? _adSearchSubscription;

  SearchProvider({required this.adService});

  SearchState _state = SearchState.initial;
  SearchState get state => _state;

  List<Ad> _ads = [];
  List<Ad> get ads => _ads;
  List<Ad> get results => _ads;  // Alias for ads

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  FilterOptions _filterOptions = FilterOptions();
  FilterOptions get filterOptions => _filterOptions;

  // Individual filter getters for convenience
  String? get searchQuery => _filterOptions.search;
  String? get selectedCategory => _filterOptions.category?.name;
  bool get isLoading => _state == SearchState.loading;

  void setFilterOptions(FilterOptions options) {
    _filterOptions = options;
    searchAds();
    notifyListeners();
  }

  // Convenience method for search with individual params
  Future<void> search({
    String? query,
    String? category,
    double? minPrice,
    double? maxPrice,
  }) async {
    _state = SearchState.loading;
    notifyListeners();

    try {
      _ads = await adService.fetchAds(
        search: query,
        category: category,
        minPrice: minPrice,
        maxPrice: maxPrice,
      );
      _state = SearchState.loaded;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _state = SearchState.error;
      notifyListeners();
    }
  }

  void searchAds() {
    _state = SearchState.loading;
    notifyListeners();

    _adSearchSubscription?.cancel();
    adService
        .fetchAds(
      search: _filterOptions.search,
      category: _filterOptions.category?.name,
      minPrice: _filterOptions.minPrice,
      maxPrice: _filterOptions.maxPrice,
    )
        .then((ads) {
      _ads = ads;
      _state = SearchState.loaded;
      notifyListeners();
    }).catchError((e) {
      _errorMessage = e.toString();
      _state = SearchState.error;
      notifyListeners();
    });
  }

  void clearFilters() {
    _filterOptions = FilterOptions();
    _ads = [];
    _state = SearchState.initial;
    notifyListeners();
  }

  @override
  void dispose() {
    _adSearchSubscription?.cancel();
    super.dispose();
  }
}
