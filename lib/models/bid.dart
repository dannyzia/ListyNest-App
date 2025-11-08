class Bid {
  final String adId;
  final double amount;
  final String userId;

  Bid({required this.adId, required this.amount, required this.userId});

  factory Bid.fromJson(Map<String, dynamic> json) {
    return Bid(
      adId: json['adId'],
      amount: json['amount'],
      userId: json['userId'],
    );
  }
}
