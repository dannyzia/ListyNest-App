import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/filter_provider.dart';

class CategoryChips extends StatelessWidget {
  const CategoryChips({super.key});

  // Replace with your actual categories
  static const List<String> _categories = [
    'Electronics',
    'Vehicles',
    'Property',
    'Home & Garden',
    'Fashion',
    'Hobbies & Kids',
    'Business & Industry',
    'Services',
  ];

  @override
  Widget build(BuildContext context) {
    final filterProvider = Provider.of<FilterProvider>(context);

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = filterProvider.category == category;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  filterProvider.setCategory(category);
                } else {
                  filterProvider.setCategory(null);
                }
                // Trigger ad search with the new filter
              },
              selectedColor: Theme.of(context).primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          );
        },
      ),
    );
  }
}
