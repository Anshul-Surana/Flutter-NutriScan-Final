import 'dart:io';
import 'package:flutter/material.dart';
import 'package:new_app/UserProfilesDatabaseHelper.dart';
import 'CategoryPage.dart';
import 'ProfilePage.dart';
import 'main.dart';

class ProfileSettingsPage extends StatefulWidget {
  final String initialName;
  final String? initialAvatarPath;

  ProfileSettingsPage({
    Key? key,
    required this.initialName,
    required this.initialAvatarPath,
  }) : super(key: key);

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  String userName = 'User';
  String? avatarImagePath;

  Future<void> loadUserProfile() async {
    try {
      final userProfile = await UserProfilesDatabaseHelper.readUserProfile();
      if (userProfile != null) {
        setState(() {
          userName = userProfile['name'] as String;
          avatarImagePath = userProfile['avatarImagePath'] as String?;
        });
      }
    } catch (e) {
      print('Error loading user profile: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Settings'),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage(title: 'NutriScan',)),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 50.0,
              backgroundImage: 
              avatarImagePath != null
                  ? FileImage(File(avatarImagePath!))
                  : AssetImage(widget.initialAvatarPath ?? 'assets/blue.jpg') as ImageProvider,

            ),
            SizedBox(height: 20.0),
            Text(
              userName,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Navigate to the profile page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(
                      initialName: widget.initialName,
                    ),
                  ),
                );
              },
              child: Text('Edit Profile'),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                Switch(
                  value: true, // Set to the actual notificationsEnabled value
                  onChanged: (bool? newValue) {
                    // Handle notification switch
                  },
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Edit Categories',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Navigate to the category page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CategoryPage()),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
