import 'package:flutter/material.dart';
import 'package:listynest/models/user_profile.dart';
import 'package:listynest/services/user_profile_service.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  UserProfileScreenState createState() => UserProfileScreenState();
}

class UserProfileScreenState extends State<UserProfileScreen> {
  final UserProfileService _userProfileService = UserProfileService();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: StreamBuilder<UserProfile>(
        stream: _userProfileService.getUserProfile(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final userProfile = snapshot.data!;
          _nameController.text = userProfile.name;
          _emailController.text = userProfile.email;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  readOnly: true,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () async {
                    final updatedProfile = UserProfile(
                      uid: userProfile.uid,
                      name: _nameController.text,
                      email: userProfile.email,
                    );
                    await _userProfileService.updateUserProfile(updatedProfile);
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile updated successfully!')),
                    );
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
