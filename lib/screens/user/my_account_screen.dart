import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyAccountScreen extends StatelessWidget {
  const MyAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('My Ads'),
            onTap: () {
              context.go('/my-ads');
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('My Favorites'),
            onTap: () {
              context.go('/my-favorites');
            },
          ),
          ListTile(
            leading: const Icon(Icons.gavel),
            title: const Text('My Bids'),
            onTap: () {
              context.go('/my-bids');
            },
          ),
        ],
      ),
    );
  }
}
