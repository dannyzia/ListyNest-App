// lib/models/category.dart
import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final IconData icon;

  Category({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: IconData(
        json['iconCode'] as int,
        fontFamily: 'MaterialIcons',
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconCode': icon.codePoint,
    };
  }

  @override
  String toString() => name;
}
