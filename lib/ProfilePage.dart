import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_app/main.dart';
import 'UserProfilesDatabaseHelper.dart';
import 'dart:io';
import 'ProfileSettingsPage.dart';

class ProfilePage extends StatefulWidget {
  final String initialName;

  ProfilePage({Key? key, required this.initialName}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController nameController;
  late TextEditingController ageController;
  late TextEditingController heightController;
  late TextEditingController weightController;
  String? avatarImagePath;
  String? name;
  bool isFirstTime = true;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    ageController = TextEditingController();
    heightController = TextEditingController();
    weightController = TextEditingController();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    try {
      final userProfile = await UserProfilesDatabaseHelper.readUserProfile();
      if (userProfile != null) {
        setState(() {
          nameController.text = userProfile['name'] as String;
          ageController.text = userProfile['age'].toString();
          heightController.text = userProfile['height'].toString();
          weightController.text = userProfile['weight'].toString();
          avatarImagePath = userProfile['avatarImagePath'] as String?;
        });
        isFirstTime = false;
      }
    } catch (e) {
      print('Error loading user profile: $e');
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50.0,
                    backgroundImage: avatarImagePath != null
                        ? FileImage(File(avatarImagePath!))
                    as ImageProvider<Object>?
                        : AssetImage('assets/blue.jpg'),
                  ),
                  InkWell(
                    onTap: () async {
                      try {
                        final imagePicker = ImagePicker();
                        final pickedImage = await imagePicker.pickImage(
                          source: ImageSource.gallery,
                        );

                        if (pickedImage != null) {
                          setState(() {
                            avatarImagePath = pickedImage.path;
                          });
                        }
                      } catch (e) {
                        print('Error picking image: $e');
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.edit,
                        size: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Text(
                'Profile Details',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: nameController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    // Handle onChanged if needed
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: ageController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Age',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    // Handle onChanged if needed
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: heightController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Height (cm)',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    // Handle onChanged if needed
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: weightController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Weight (kg)',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    // Handle onChanged if needed
                  },
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  await UserProfilesDatabaseHelper.createUserProfile(
                    nameController.text,
                    int.parse(ageController.text),
                    double.parse(heightController.text),
                    double.parse(weightController.text),
                    avatarImagePath,
                  );
                  // Reload user profile after saving
                  loadUserProfile();

                  // Navigate to ProfileSettingsPage with updated data
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyHomePage(title: 'NutriScan',passIndex: 2,),
                  ),
                  );
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
