
import 'package:listynest/models/ad.dart';

class Favorite {
  final String id;
  final String userId;
  final Ad ad;

  Favorite({required this.id, required this.userId, required this.ad});

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      id: json['_id'],
      userId: json['user'],
      ad: Ad.fromJson(json['ad']),
    );
  }
}
