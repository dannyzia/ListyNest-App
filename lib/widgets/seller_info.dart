import 'package:flutter/material.dart';

class SellerInfo extends StatelessWidget {
  const SellerInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Seller Information', style: Theme.of(context).textTheme.titleMedium),
          // Add seller details here
        ],
      ),
    );
  }
}
