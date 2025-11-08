import 'package:flutter/material.dart';
import 'package:listynest/models/user_profile.dart';
import 'package:listynest/services/user_profile_service.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final UserProfileService _userProfileService = UserProfileService();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: StreamBuilder<UserProfile>(
        stream: _userProfileService.getUserProfile(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
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
                  decoration: InputDecoration(
                    labelText: 'Name',
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                  readOnly: true,
                ),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () async {
                    final updatedProfile = UserProfile(
                      uid: userProfile.uid,
                      name: _nameController.text,
                      email: userProfile.email,
                    );
                    await _userProfileService.updateUserProfile(updatedProfile);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Profile updated successfully!')),
                    );
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
