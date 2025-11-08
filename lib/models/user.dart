class User {
  final String id;
  final String name;
  final String email;
  final String? avatar;
  final String? phone;
  final DateTime? memberSince;
  final List<String> favorites;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.phone,
    this.memberSince,
    this.favorites = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      avatar: json['avatar'],
      phone: json['phone'],
      memberSince: json['memberSince'] != null
          ? DateTime.parse(json['memberSince'])
          : null,
      favorites: List<String>.from(json['favorites'] ?? []),
    );
  }
}
