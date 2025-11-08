import 'package:flutter/material.dart';

class CategorySelector extends StatelessWidget {
  const CategorySelector({super.key});

  @override
  Widget build(BuildContext context) {
    // Replace with actual categories
    final categories = ['Electronics', 'Furniture', 'Fashion', 'Cars'];

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Chip(
              label: Text(categories[index]),
              backgroundColor: Colors.grey[200],
            ),
          );
        },
      ),
    );
  }
}
