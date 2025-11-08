import 'package:flutter/foundation.dart';
import 'package:listynest/models/favorite_model.dart';
import 'package:listynest/services/favorite_service.dart';

class FavoriteProvider with ChangeNotifier {
  final FavoriteService _favoriteService;

  List<Favorite> _favorites = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Favorite> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  FavoriteProvider(this._favoriteService);

  Future<void> fetchFavorites() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _favorites = await _favoriteService.getFavorites();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
