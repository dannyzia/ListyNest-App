import 'package:flutter/material.dart';

class AdListItem extends StatelessWidget {
  const AdListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('Ad List Item Placeholder'),
      ),
    );
  }
}
