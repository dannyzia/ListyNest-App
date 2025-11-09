
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

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  FilterOptions _filterOptions = FilterOptions();
  FilterOptions get filterOptions => _filterOptions;

  void setFilterOptions(FilterOptions options) {
    _filterOptions = options;
    searchAds();
    notifyListeners();
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

  @override
  void dispose() {
    _adSearchSubscription?.cancel();
    super.dispose();
  }
}
