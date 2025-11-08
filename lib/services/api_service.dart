import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://api.yourapp.com', // TODO: Replace with your API base URL
  ));

  Future<void> placeBid(String adId, double amount) async {
    try {
      await _dio.post('/bids', data: {'adId': adId, 'amount': amount});
    } catch (e) {
      // TODO: Handle error
      print(e);
    }
  }
}
