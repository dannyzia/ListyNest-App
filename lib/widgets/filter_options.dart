import 'package:flutter/material.dart';

class FilterOptions extends StatelessWidget {
  const FilterOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: const Column(
        children: [
          Text('Filter Options'),
          // Add filter widgets here
        ],
      ),
    );
  }
}
