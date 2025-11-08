class Blog {
  final String id;
  final String title;
  final String excerpt;
  final String content;
  final String author;
  final String image;
  final String category;
  final String status;
  final DateTime publishDate;
  final int views;
  final String slug;

  Blog({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.content,
    required this.author,
    required this.image,
    required this.category,
    required this.status,
    required this.publishDate,
    required this.views,
    required this.slug,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      id: json['id'],
      title: json['title'],
      excerpt: json['excerpt'],
      content: json['content'],
      author: json['author'],
      image: json['image'],
      category: json['category'],
      status: json['status'],
      publishDate: DateTime.parse(json['publishDate']),
      views: json['views'],
      slug: json['slug'],
    );
  }
}
