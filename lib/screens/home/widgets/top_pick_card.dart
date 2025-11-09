import 'package:flutter/material.dart';

class TopPickCard extends StatelessWidget {
  const TopPickCard({super.key});

  // Top pick model will be passed here

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          color: Colors.grey[400],
          child: const Center(child: Text('Image')),
        ),
        title: const Text('Top Pick Title'),
        subtitle: const Text('Top Pick Subtitle'),
        onTap: () {
          // Handle tap
        },
      ),
    );
  }
}
