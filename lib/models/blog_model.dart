import '../models/user_model.dart';

class Blog {
  final String id;
  final String title;
  final String excerpt;
  final String content;
  final String authorId;
  final User? author;
  final BlogImage? image;
  final String category;
  final String status;
  final DateTime publishDate;
  final int views;
  final String slug;
  final DateTime createdAt;

  Blog({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.content,
    required this.authorId,
    this.author,
    this.image,
    required this.category,
    required this.status,
    required this.publishDate,
    required this.views,
    required this.slug,
    required this.createdAt,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      id: json['_id'],
      title: json['title'],
      excerpt: json['excerpt'],
      content: json['content'],
      authorId: json['author'] is String ? json['author'] : json['author']['_id'],
      author: json['author'] is Map ? User.fromJson(json['author']) : null,
      image: json['image'] != null ? BlogImage.fromJson(json['image']) : null,
      category: json['category'],
      status: json['status'],
      publishDate: DateTime.parse(json['publishDate']),
      views: json['views'] ?? 0,
      slug: json['slug'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class BlogImage {
  final String url;
  final String? publicId;

  BlogImage({required this.url, this.publicId});

  factory BlogImage.fromJson(Map<String, dynamic> json) {
    return BlogImage(
      url: json['url'],
      publicId: json['publicId'],
    );
  }
}
