import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:listynest/providers/auth_provider.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Profile'),
            onTap: () {
              context.go('/profile');
            },
          ),
          ListTile(
            leading: const Icon(Icons.list_alt_outlined),
            title: const Text('My Ads'),
            onTap: () {
              context.go('/my-ads');
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite_border),
            title: const Text('My Favorites'),
            onTap: () {
              context.go('/my-favorites');
            },
          ),
          ListTile(
            leading: const Icon(Icons.gavel_outlined),
            title: const Text('My Bids'),
            onTap: () {
              context.go('/my-bids');
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: const Text('Post an Ad'),
            onTap: () {
              context.go('/post-ad');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            onTap: () {
              context.go('/settings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help Center'),
            onTap: () {
              context.go('/help');
            },
          ),
          ListTile(
            leading: const Icon(Icons.document_scanner_outlined),
            title: const Text('Terms & Conditions'),
            onTap: () {
              context.go('/terms');
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy Policy'),
            onTap: () {
              context.go('/privacy');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.star_border_outlined),
            title: const Text('Rate App'),
            onTap: () {
              // Add app rating logic here
            },
          ),
          ListTile(
            leading: const Icon(Icons.share_outlined),
            title: const Text('Share App'),
            onTap: () {
              // Add app sharing logic here
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
              context.go('/');
            },
          ),
        ],
      ),
    );
  }
}
