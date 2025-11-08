class AdImage {
  final String url;
  final String? publicId;
  final int? order;

  AdImage({
    required this.url,
    this.publicId,
    this.order,
  });

  factory AdImage.fromJson(Map<String, dynamic> json) {
    return AdImage(
      url: json['url'],
      publicId: json['publicId'],
      order: json['order'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'publicId': publicId,
      'order': order,
    };
  }
}
