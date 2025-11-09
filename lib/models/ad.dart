import 'package:cloud_firestore/cloud_firestore.dart';

class Location {
  final String country;
  final String state;
  final String city;

  Location({
    required this.country,
    required this.state,
    required this.city,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      country: json['country'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'country': country,
    'state': state,
    'city': city,
  };

  @override
  String toString() => '$city, $state, $country';
}

class Ad {
  final String id;
  final String title;
  final String description;
  final double price;
  final String? currency;
  final String? category;
  final Location? location;
  final List<String> imageUrls; 
  final String userId;
  final String? contactEmail;
  final String? contactPhone;
  final String? status;
  final bool isFeatured;
  final int views;
  final List<String> favoritedBy;
  final DateTime? expiresAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Ad({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.currency,
    this.category,
    this.location,
    this.imageUrls = const [],
    required this.userId,
    this.contactEmail,
    this.contactPhone,
    this.status,
    this.isFeatured = false,
    this.views = 0,
    this.favoritedBy = const [],
    this.expiresAt,
    this.createdAt,
    this.updatedAt,
  });

  factory Ad.fromJson(Map<String, dynamic> json) {
    return Ad(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'USD',
      category: json['category'] ?? '',
      location: Location.fromJson(json['location'] ?? {}),
      imageUrls: List<String>.from(json['images'] ?? json['imageUrls'] ?? []),
      userId: json['user'] is String ? json['user'] : (json['user']?['_id'] ?? json['userId'] ?? ''),
      contactEmail: json['contactEmail'],
      contactPhone: json['contactPhone'],
      status: json['status'] ?? 'active',
      isFeatured: json['isFeatured'] ?? false,
      views: json['views'] ?? 0,
      favoritedBy: List<String>.from(json['favoritedBy'] ?? []),
      expiresAt: json['expiresAt'] != null 
          ? DateTime.parse(json['expiresAt']) 
          : DateTime.now().add(const Duration(days: 30)),
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : DateTime.now(),
    );
  }

  factory Ad.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Ad.fromJson({...data, 'id': doc.id});
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'price': price,
    'currency': currency,
    'category': category,
    'location': location?.toJson(),
    'imageUrls': imageUrls,
    'userId': userId,
    'contactEmail': contactEmail,
    'contactPhone': contactPhone,
    'status': status,
    'isFeatured': isFeatured,
    'views': views,
    'favoritedBy': favoritedBy,
    'expiresAt': expiresAt?.toIso8601String(),
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };

  Ad copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    String? currency,
    String? category,
    Location? location,
    List<String>? imageUrls,
    String? userId,
    String? contactEmail,
    String? contactPhone,
    String? status,
    bool? isFeatured,
    int? views,
    List<String>? favoritedBy,
    DateTime? expiresAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Ad(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      category: category ?? this.category,
      location: location ?? this.location,
      imageUrls: imageUrls ?? this.imageUrls,
      userId: userId ?? this.userId,
      contactEmail: contactEmail ?? this.contactEmail,
      contactPhone: contactPhone ?? this.contactPhone,
      status: status ?? this.status,
      isFeatured: isFeatured ?? this.isFeatured,
      views: views ?? this.views,
      favoritedBy: favoritedBy ?? this.favoritedBy,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
