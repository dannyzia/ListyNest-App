import '../models/blog_model.dart';
import 'api_service.dart';

class BlogService {
  final ApiService _apiService;

  BlogService(this._apiService);

  Future<List<Blog>> getFeaturedBlogs() async {
    try {
      final response = await _apiService.get('/blogs/featured');
      return (response.data['blogs'] as List)
          .map((json) => Blog.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load featured blogs: ${e.toString()}');
    }
  }

  Future<Blog> getBlog(String slug) async {
    try {
      final response = await _apiService.get('/blogs/$slug');
      return Blog.fromJson(response.data['blog']);
    } catch (e) {
      throw Exception('Failed to load blog: ${e.toString()}');
    }
  }

  Future<List<Blog>> getAllBlogs() async {
    try {
      final response = await _apiService.get('/blogs/all');
      return (response.data['blogs'] as List)
          .map((json) => Blog.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load all blogs: ${e.toString()}');
    }
  }
}
