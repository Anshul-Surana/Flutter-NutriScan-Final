import 'package:flutter/material.dart';
import 'IngredientsImagePage.dart';

class CameraPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // Navigate to the CameraPage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => IngredientsImagePage(
                onTextExtracted: (String ingredientsText, String tableText) {
                },
              ),
            ),
          );
        },
        child: Text('Open Camera'),
      ),
    );
  }
}
