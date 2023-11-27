import 'dart:io';
import 'package:flutter/material.dart';
import 'CategoryPage.dart';
import 'ProfilePage.dart';
import 'main.dart';

class ProfileSettingsPage extends StatelessWidget {
  final String initialName;
  final String? initialAvatarPath;

  ProfileSettingsPage({
    Key? key,
    required this.initialName,
    required this.initialAvatarPath,
  }) : super(key: key);

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
              backgroundImage: initialAvatarPath != null
                  ? FileImage(File(initialAvatarPath!))
              as ImageProvider<Object>?
                  : AssetImage('assets/blue.jpg'),
            ),
            SizedBox(height: 20.0),
            Text(
              initialName,
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
                      initialName: initialName,
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
