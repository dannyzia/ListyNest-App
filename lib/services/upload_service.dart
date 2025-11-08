import 'dart:io';
import 'package:dio/dio.dart';
import 'api_service.dart';

class UploadService {
  final ApiService _apiService;

  UploadService(this._apiService);

  Future<String> uploadImage(File image) async {
    try {
      String fileName = image.path.split('/').last;
      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(image.path, filename: fileName),
      });
      final response = await _apiService.post('/upload/images', data: formData);
      return response.data['imageUrl'];
    } catch (e) {
      throw Exception('Failed to upload image: ${e.toString()}');
    }
  }
}
