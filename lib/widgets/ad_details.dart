import 'package:flutter/material.dart';

class AdDetails extends StatelessWidget {
  const AdDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 200,
          color: Colors.grey[300],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Ad Title', style: Theme.of(context).textTheme.titleLarge),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Ad Description'),
        ),
      ],
    );
  }
}
