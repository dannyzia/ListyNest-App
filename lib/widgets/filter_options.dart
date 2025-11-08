import 'package:flutter/material.dart';

class FilterOptions extends StatelessWidget {
  const FilterOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text('Filter Options'),
          // Add filter widgets here
        ],
      ),
    );
  }
}
