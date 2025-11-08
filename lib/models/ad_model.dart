import 'package:cloud_firestore/cloud_firestore.dart';

class Ad {
  final String id;
  final String userId;
  final String title;
  final String description;
  final double price;
  final String currency;
  final String category;
  final String location;
  final List<AdImage> images;
  final String status;
  final bool isFeatured;
  final int views;
  final DateTime expiresAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final AuctionDetails? auctionDetails;

  Ad({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.price,
    this.currency = 'USD',
    required this.category,
    required this.location,
    required this.images,
    this.status = 'active',
    this.isFeatured = false,
    this.views = 0,
    required this.expiresAt,
    required this.createdAt,
    required this.updatedAt,
    this.auctionDetails,
  });

  factory Ad.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Ad(
      id: doc.id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      currency: data['currency'] ?? 'USD',
      category: data['category'] ?? '',
      location: data['location'] ?? '',
      images: (data['images'] as List<dynamic>? ?? [])
          .map((image) => AdImage.fromFirestore(image))
          .toList(),
      status: data['status'] ?? 'active',
      isFeatured: data['isFeatured'] ?? false,
      views: data['views'] ?? 0,
      expiresAt: (data['expiresAt'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      auctionDetails: data['auctionDetails'] != null
          ? AuctionDetails.fromFirestore(data['auctionDetails'])
          : null,
    );
  }

  Ad copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    double? price,
    String? currency,
    String? category,
    String? location,
    List<AdImage>? images,
    String? status,
    bool? isFeatured,
    int? views,
    DateTime? expiresAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    AuctionDetails? auctionDetails,
  }) {
    return Ad(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      category: category ?? this.category,
      location: location ?? this.location,
      images: images ?? this.images,
      status: status ?? this.status,
      isFeatured: isFeatured ?? this.isFeatured,
      views: views ?? this.views,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      auctionDetails: auctionDetails ?? this.auctionDetails,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'price': price,
      'currency': currency,
      'category': category,
      'location': location,
      'images': images.map((image) => image.toJson()).toList(),
      'status': status,
      'isFeatured': isFeatured,
      'views': views,
      'expiresAt': expiresAt,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'auctionDetails': auctionDetails?.toJson(),
    };
  }
}

class AdImage {
  final String url;
  final String caption;

  AdImage({required this.url, this.caption = ''});

  factory AdImage.fromFirestore(Map<String, dynamic> data) {
    return AdImage(
      url: data['url'] ?? '',
      caption: data['caption'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'caption': caption,
    };
  }
}

class AuctionDetails {
  final double startingBid;
  final double currentBid;
  final DateTime endTime;
  final List<Bid> bids;

  AuctionDetails({
    required this.startingBid,
    required this.currentBid,
    required this.endTime,
    required this.bids,
  });

  factory AuctionDetails.fromFirestore(Map<String, dynamic> data) {
    return AuctionDetails(
      startingBid: (data['startingBid'] ?? 0).toDouble(),
      currentBid: (data['currentBid'] ?? 0).toDouble(),
      endTime: (data['endTime'] as Timestamp).toDate(),
      bids: (data['bids'] as List<dynamic>? ?? [])
          .map((bid) => Bid.fromFirestore(bid))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startingBid': startingBid,
      'currentBid': currentBid,
      'endTime': endTime,
      'bids': bids.map((bid) => bid.toJson()).toList(),
    };
  }
}

class Bid {
  final String userId;
  final double amount;
  final DateTime timestamp;

  Bid({
    required this.userId,
    required this.amount,
    required this.timestamp,
  });

  factory Bid.fromFirestore(Map<String, dynamic> data) {
    return Bid(
      userId: data['userId'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'amount': amount,
      'timestamp': timestamp,
    };
  }
}
