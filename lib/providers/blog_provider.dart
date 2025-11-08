import 'package:flutter/foundation.dart';
import '../models/blog_model.dart';
import '../services/blog_service.dart';

class BlogProvider with ChangeNotifier {
  final BlogService _blogService;

  List<Blog> _featuredBlogs = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Blog> get featuredBlogs => _featuredBlogs;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  BlogProvider(this._blogService);

  Future<void> fetchFeaturedBlogs() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _featuredBlogs = await _blogService.getFeaturedBlogs();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
