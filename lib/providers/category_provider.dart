
import 'package:flutter/material.dart';
import 'package:listynest/models/category_model.dart';
import 'package:listynest/services/category_service.dart';

enum CategoryState { initial, loading, loaded, error }

class CategoryProvider extends ChangeNotifier {
  final CategoryService _categoryService = CategoryService();
  List<Category> _categories = [];
  CategoryState _state = CategoryState.initial;
  String _errorMessage = '';

  List<Category> get categories => _categories;
  CategoryState get state => _state;
  String get errorMessage => _errorMessage;

  Future<void> fetchCategories() async {
    _state = CategoryState.loading;
    notifyListeners();
    try {
      _categories = await _categoryService.fetchCategories();
      _state = CategoryState.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _state = CategoryState.error;
    }
    notifyListeners();
  }
}
