// lib/providers/category_provider.dart
import 'package:flutter/material.dart';
import '../models/category.dart';

enum CategoryState {
  initial,
  loading,
  loaded,
  error,
}

class CategoryProvider with ChangeNotifier {
  List<Category> _categories = [];
  CategoryState _state = CategoryState.initial;
  String? _errorMessage;
  bool _isLoading = false;
  
  List<Category> get categories => _categories;
  CategoryState get state => _state;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  
  // Initialize with default categories
  CategoryProvider() {
    _initializeCategories();
  }
  
  void _initializeCategories() {
    _categories = [
      Category(id: '1', name: 'Electronics', icon: Icons.phone_android),
      Category(id: '2', name: 'Vehicles', icon: Icons.directions_car),
      Category(id: '3', name: 'Real Estate', icon: Icons.home),
      Category(id: '4', name: 'Jobs', icon: Icons.work),
      Category(id: '5', name: 'Services', icon: Icons.build),
      Category(id: '6', name: 'Fashion', icon: Icons.watch),
      Category(id: '7', name: 'Home & Garden', icon: Icons.chair),
      Category(id: '8', name: 'Sports', icon: Icons.sports_soccer),
      Category(id: '9', name: 'Books', icon: Icons.book),
      Category(id: '10', name: 'Pets', icon: Icons.pets),
    ];
    _state = CategoryState.loaded;
    notifyListeners();
  }
  
  Future<void> fetchCategories() async {
    _isLoading = true;
    _state = CategoryState.loading;
    notifyListeners();
    
    try {
      // Categories are already initialized, just mark as loaded
      _state = CategoryState.loaded;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _state = CategoryState.error;
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Category? getCategoryById(String id) {
    try {
      return _categories.firstWhere((cat) => cat.id == id);
    } catch (e) {
      return null;
    }
  }
  
  Category? getCategoryByName(String name) {
    try {
      return _categories.firstWhere((cat) => cat.name == name);
    } catch (e) {
      return null;
    }
  }
}
