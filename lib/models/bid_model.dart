import '../models/user_model.dart';

class Bid {
  final String id;
  final String auctionId;
  final String userId;
  final User? user;
  final double amount;
  final DateTime createdAt;

  Bid({
    required this.id,
    required this.auctionId,
    required this.userId,
    this.user,
    required this.amount,
    required this.createdAt,
  });

  factory Bid.fromJson(Map<String, dynamic> json) {
    return Bid(
      id: json['_id'],
      auctionId: json['auctionId'],
      userId: json['user'] is String ? json['user'] : json['user']['_id'],
      user: json['user'] is Map ? User.fromJson(json['user']) : null,
      amount: json['amount'].toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
