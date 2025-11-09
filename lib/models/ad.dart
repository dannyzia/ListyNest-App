
class Ad {
  final String id;
  final String title;
  final String description;
  final double price;
  final String userId;
  final List<String> imageUrls; // Not 'images'
  final String category;
  final String location;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? expiresAt;
  
  Ad({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.userId,
    required this.imageUrls,
    required this.category,
    required this.location,
    required this.createdAt,
    required this.updatedAt,
    this.expiresAt,
  });
  
  factory Ad.fromJson(Map<String, dynamic> json) {
    return Ad(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      userId: json['userId'] ?? '',
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      category: json['category'] ?? '',
      location: json['location'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      expiresAt: json['expiresAt'] != null ? DateTime.parse(json['expiresAt']) : null,
    );
  }
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'price': price,
    'userId': userId,
    'imageUrls': imageUrls,
    'category': category,
    'location': location,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'expiresAt': expiresAt?.toIso8601String(),
  };
}
