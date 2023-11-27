import 'package:flutter/material.dart';
import 'CameraPage.dart';
import 'ProfileSettingsPage.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.white,
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'NutriScan'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  String ingredientsImageText =
      ''; // To store the text from IngredientsImagePage
  String tableImageText = ''; // To store the text from TableImagePage
  late String initialAvatarPath;

    final List<Widget> _pages = [
      HomePage(),
      CameraPage(),
      ProfileSettingsPage(
        initialName: 'User',
        initialAvatarPath: 'assets/blue.jpg',),
    ];

  @override
  void initState() {
    super.initState();
  }
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Text(widget.title),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 20.0,
                backgroundImage: AssetImage('assets/blue.jpg'),
              ),
            ),
          ],
        ),
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera),
              label: 'Camera',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          selectedItemColor: Colors.deepPurple,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      );
    }
  }


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'This is a Card',
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
                LinearProgressIndicator(
                  value: 0.5,
                  backgroundColor: Colors.grey,
                ),
              ],
            ),
          ),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            children: <Widget>[
              // Grid Item 1 ...
              Padding(
                padding: const EdgeInsets.all(8.0), // Add padding
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius:
                        BorderRadius.circular(10.0), // Rounded corners
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Grid Item 1',
                        style: TextStyle(color: Colors.white),
                      ),
                      LinearProgressIndicator(
                        value: 0.5, // Change the value as needed
                        backgroundColor:
                            Colors.grey, // Set widget color to gray
                      ),
                    ],
                  ),
                ),
              ),

              // Grid Item 2
              Padding(
                padding: const EdgeInsets.all(8.0), // Add padding
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius:
                        BorderRadius.circular(10.0), // Rounded corners
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Grid Item 2',
                        style: TextStyle(color: Colors.white),
                      ),
                      LinearProgressIndicator(
                        value: 0.3, // Change the value as needed
                        backgroundColor:
                            Colors.grey, // Set widget color to gray
                      ),
                    ],
                  ),
                ),
              ),

              // Grid Item 3
              Padding(
                padding: const EdgeInsets.all(8.0), // Add padding
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius:
                        BorderRadius.circular(10.0), // Rounded corners
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Grid Item 3',
                        style: TextStyle(color: Colors.white),
                      ),
                      LinearProgressIndicator(
                        value: 0.7, // Change the value as needed
                        backgroundColor:
                            Colors.grey, // Set widget color to gray
                      ),
                    ],
                  ),
                ),
              ),

              // Grid Item 4
              Padding(
                padding: const EdgeInsets.all(8.0), // Add padding
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius:
                        BorderRadius.circular(10.0), // Rounded corners
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Grid Item 4',
                        style: TextStyle(color: Colors.white),
                      ),
                      LinearProgressIndicator(
                        value: 0.2, // Change the value as needed
                        backgroundColor:
                            Colors.grey, // Set widget color to gray
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
