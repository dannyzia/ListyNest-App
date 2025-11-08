import 'package:listynest/models/ad_image.dart';
import 'package:listynest/models/links.dart';
import 'package:listynest/models/location.dart';
import 'package:listynest/models/user.dart';

class Ad {
  final String id;
  final String title;
  final String description;
  final double? price;
  final String? currency;
  final String category;
  final Location location;
  final List<AdImage> images;
  final String userId;
  final User? user;
  final String? contactEmail;
  final String? contactPhone;
  final Links? links;
  final String status;
  final bool isFeatured;
  final int views;
  final List<String> favoritedBy;
  final DateTime expiresAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? auctionDetails;
  final Map<String, dynamic>? details;

  Ad({
    required this.id,
    required this.title,
    required this.description,
    this.price,
    this.currency,
    required this.category,
    required this.location,
    required this.images,
    required this.userId,
    this.user,
    this.contactEmail,
    this.contactPhone,
    this.links,
    required this.status,
    required this.isFeatured,
    required this.views,
    required this.favoritedBy,
    required this.expiresAt,
    required this.createdAt,
    required this.updatedAt,
    this.auctionDetails,
    this.details,
  });

  factory Ad.fromJson(Map<String, dynamic> json) {
    return Ad(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      price: json['price']?.toDouble(),
      currency: json['currency'],
      category: json['category'],
      location: Location.fromJson(json['location']),
      images: (json['images'] as List?)
              ?.map((e) => AdImage.fromJson(e))
              .toList() ??
          [],
      userId: json['user'] is String ? json['user'] : json['user']['_id'],
      user: json['user'] is Map ? User.fromJson(json['user']) : null,
      contactEmail: json['contactEmail'],
      contactPhone: json['contactPhone'],
      links: json['links'] != null ? Links.fromJson(json['links']) : null,
      status: json['status'],
      isFeatured: json['isFeatured'] ?? false,
      views: json['views'] ?? 0,
      favoritedBy: List<String>.from(json['favoritedBy'] ?? []),
      expiresAt: DateTime.parse(json['expiresAt']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      auctionDetails: json['auctionDetails'],
      details: json['details'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'currency': currency,
      'category': category,
      'location': location.toJson(),
      'contactEmail': contactEmail,
      'contactPhone': contactPhone,
      'links': links?.toJson(),
      'details': details,
      'auctionDetails': auctionDetails,
    };
  }
}
