class Feedback {
  final String adId;
  final String userId;
  final String feedback;

  Feedback({required this.adId, required this.userId, required this.feedback});

  Map<String, dynamic> toJson() => {
        'adId': adId,
        'userId': userId,
        'feedback': feedback,
      };
}
