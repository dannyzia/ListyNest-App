import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:listynest/models/favorite_model.dart';
import 'package:listynest/services/favorite_service.dart';

class FavoriteProvider with ChangeNotifier {
  final FavoriteService _favoriteService;
  late StreamSubscription<List<Favorite>> _favoritesSubscription;

  List<Favorite> _favorites = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Favorite> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  FavoriteProvider(this._favoriteService) {
    _favoritesSubscription = _favoriteService.getFavorites().listen((favorites) {
      _favorites = favorites;
      _isLoading = false;
      notifyListeners();
    }, onError: (error) {
      _errorMessage = error.toString();
      _isLoading = false;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _favoritesSubscription.cancel();
    super.dispose();
  }
}
