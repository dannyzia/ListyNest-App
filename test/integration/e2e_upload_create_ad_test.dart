import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final apiBase = Platform.environment['API_BASE_URL'];
  final email = Platform.environment['BACKEND_TEST_USER_EMAIL'];
  final password = Platform.environment['BACKEND_TEST_USER_PASSWORD'];

  final shouldRun = apiBase != null && apiBase.isNotEmpty && email != null && email.isNotEmpty && password != null && password.isNotEmpty;

  if (!shouldRun) {
    group('E2E: upload & create ad', () {
      test('skipped - missing env', () {}, skip: 'Skipping E2E tests because API_BASE_URL or test credentials are not set.');
    });
    return;
  }

  // non-null bindings (we already checked shouldRun above)
  final base = apiBase;
  final userEmail = email;
  final userPassword = password;

  group('E2E: upload & create ad', () {
    String? token;
    String? createdAdId;
    List<String> uploadedUrls = [];

    test('login', () async {
      final resp = await http.post(
        Uri.parse('$base/auth/login'),
        headers: { 'Content-Type': 'application/json' },
        body: jsonEncode({ 'email': userEmail, 'password': userPassword }),
      );
      expect(resp.statusCode, anyOf([200, 201]));
      final body = jsonDecode(resp.body);
      token = body['token'] as String? ?? (body['data']?['token'] as String?);
      expect(token, isNotNull, reason: 'token should be present after login');
    });

    test('upload image', () async {
      // Build a minimal valid 1x1 PNG in memory
      final imageBytes = <int>[
        0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, // PNG signature
        0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52, // IHDR chunk
        0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, // 1x1 dimensions
        0x08, 0x02, 0x00, 0x00, 0x00, 0x90, 0x77, 0x53, 0xDE, // IHDR data
        0x00, 0x00, 0x00, 0x0C, 0x49, 0x44, 0x41, 0x54, // IDAT chunk
        0x08, 0x99, 0x63, 0xF8, 0x0F, 0x00, 0x00, 0x01, // IDAT data
        0x00, 0x01, 0x9A, 0x60, 0xE1, 0xD5, // IDAT CRC
        0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, // IEND chunk
        0xAE, 0x42, 0x60, 0x82, // IEND CRC
      ];

  final uri = Uri.parse('$base/upload/images');
      final request = http.MultipartRequest('POST', uri);
      request.files.add(http.MultipartFile.fromBytes(
        'files', 
        imageBytes, 
        filename: 'test.png',
        contentType: MediaType('image', 'png'), // Add proper MIME type
      ));
      if (token != null) request.headers['Authorization'] = 'Bearer $token';

      final streamed = await request.send();
      final resp = await http.Response.fromStream(streamed);
      if (resp.statusCode != 200 && resp.statusCode != 201) {
        print('Upload failed: ${resp.statusCode}');
        print('Response body: ${resp.body}');
      }
      expect(resp.statusCode, anyOf([200, 201]));
      final body = jsonDecode(resp.body);

      // normalize a couple of common response shapes
      if (body is List) {
        uploadedUrls = body.map<String>((e) => e is String ? e : (e['url'] as String)).toList();
      } else if (body is Map && body['data'] != null) {
        final data = body['data'];
        if (data is List) uploadedUrls = data.map<String>((e) => e['url'] as String).toList();
        if (data is Map && data['urls'] != null) uploadedUrls = List<String>.from(data['urls']);
      } else if (body['urls'] != null) {
        uploadedUrls = List<String>.from(body['urls']);
      }

      expect(uploadedUrls, isNotEmpty, reason: 'Upload should return at least one URL');
    });

    test('create ad', () async {
      final imageUrl = uploadedUrls.isNotEmpty ? uploadedUrls.first : null;
      final adPayload = {
        'title': 'E2E Test Ad ${DateTime.now().toIso8601String()}',
        'description': 'Temporary ad created by E2E tests. Will be removed.',
        'price': 1,
        'currency': 'USD',
        'category': 'Electronics', // Use valid category (capitalized)
        'location': { 
          'city': 'Test City',
          'state': 'Test State',
          'country': 'Test Country',
        },
        'images': imageUrl != null ? [{'url': imageUrl, 'order': 0}] : [],
      };

      final resp = await http.post(
        Uri.parse('$base/ads'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(adPayload),
      );
      if (resp.statusCode != 200 && resp.statusCode != 201) {
        print('Create ad failed: ${resp.statusCode}');
        print('Response body: ${resp.body}');
      }
      expect(resp.statusCode, anyOf([200, 201]));
      final body = jsonDecode(resp.body);
      print('Create ad response: $body'); // Debug output
      createdAdId = body['ad']?['_id'] as String? ?? body['id'] as String? ?? body['_id'] as String? ?? (body['data']?['_id'] as String?);
      expect(createdAdId, isNotNull, reason: 'created ad id should be returned');
    });

    test('cleanup', () async {
      if (createdAdId == null) return;
      final resp = await http.delete(
        Uri.parse('$base/ads/$createdAdId'),
        headers: { if (token != null) 'Authorization': 'Bearer $token' },
      );
      expect(resp.statusCode, anyOf([200, 204]));
    });
  });
}
