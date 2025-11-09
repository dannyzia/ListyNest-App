import 'package:flutter/material.dart';
import 'package:listynest/models/category.dart';

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Implement category tap functionality
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // You can add an icon or image for the category here
            const Icon(Icons.category, size: 40.0),
            const SizedBox(height: 8.0),
            Text(
              category.name,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
    );
  }
}
