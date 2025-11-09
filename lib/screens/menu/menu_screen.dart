import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:listynest/providers/auth_provider.dart';

import '../profile/profile_screen.dart';
import '../profile/favorites_screen.dart';
import '../post_ad/post_ad_screen.dart';
import '../settings/settings_screen.dart';
import '../support/help_center_screen.dart';
import '../support/terms_conditions_screen.dart';
import '../support/privacy_policy_screen.dart';
import '../auth/login_screen.dart';

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
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.list_alt_outlined),
            title: const Text('My Ads'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const Placeholder()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite_border),
            title: const Text('My Favorites'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoritesScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.gavel_outlined),
            title: const Text('My Bids'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const Placeholder()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: const Text('Post an Ad'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const PostAdScreen()));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help Center'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpCenterScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.document_scanner_outlined),
            title: const Text('Terms & Conditions'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const TermsConditionsScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy Policy'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()));
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
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
