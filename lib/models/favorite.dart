class Favorite {
  final String adId;
  final String userId;

  Favorite({required this.adId, required this.userId});

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      adId: json['adId'],
      userId: json['userId'],
    );
  }
}
