import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();

  // Replace with your API base URL
  static const String _baseUrl = 'https://api.example.com/';

  Future<Response> get(String path) async {
    return await _dio.get(_baseUrl + path);
  }

  Future<Response> post(String path, dynamic data) async {
    return await _dio.post(_baseUrl + path, data: data);
  }
}
