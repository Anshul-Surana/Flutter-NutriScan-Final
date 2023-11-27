import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'AnalysisPage.dart';
import 'TableImagePage.dart';

class IngredientsImagePage extends StatefulWidget {
  final Function(String, String) onTextExtracted;

  IngredientsImagePage({Key? key, required this.onTextExtracted}) : super(key: key);

  @override
  _IngredientsImagePageState createState() => _IngredientsImagePageState();
}

class _IngredientsImagePageState extends State<IngredientsImagePage> {
  late CameraController _cameraController;
  bool _isCameraReady = false;
  bool _isReScan = false;
  XFile? _imageFile;
  String? _extractedText;

  @override
  void initState() {
    super.initState();

    // Initialize the camera
    availableCameras().then((cameras) {
      if (cameras.isEmpty) {
        print('No cameras available');
      } else {
        _initializeCamera(cameras.first);
      }
    });
  }

  Future<void> _initializeCamera(CameraDescription cameraDescription) async {
    _cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.veryHigh,
    );

    try {
      await _cameraController.initialize();
    } catch (e) {
      print('Error initializing camera: $e');
    }

    if (mounted) {
      setState(() {
        _isCameraReady = true;
      });
    }
  }

  Future<void> _takePicture() async {
    if (!_isCameraReady) return;

    try {
      final XFile picture = await _cameraController.takePicture();
      setState(() {
        _imageFile = picture;
        _isReScan = true;

        // Extract text and call the callback function
        _extractAndNotify();
      });
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedImage =
    await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _imageFile = pickedImage;
        _isReScan = true;

        // Extract text and call the callback function
        _extractAndNotify();
      });
    }
  }

  Future<void> _extractAndNotify() async {
    final textRecognizer = TextRecognizer();

    try {
      // Use the original image for text recognition (without preprocessing)
      final inputImage = InputImage.fromFile(File(_imageFile!.path));
      final RecognizedText recognizedText =
      await textRecognizer.processImage(inputImage);
      _extractedText = recognizedText.text;

      // Call the callback function to notify the parent widget with the extracted text
      widget.onTextExtracted(_extractedText!, "");
    } catch (e) {
      print('Error during text extraction: $e');
    } finally {
      textRecognizer.close();
    }
  }

  Future<void> _rescan() async {
    // Clear the previously captured image
    setState(() {
      _imageFile = null;
      _isReScan = false;
    });
  }

  Future<void> _route() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TableImagePage(
          onTextExtracted: (String ingredientsExtractedText, String tableExtractedText) {
            // Navigate to AnalysisPage.dart with both extracted texts
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AnalysisPage(
                  ingredientsExtractedText: _extractedText!,
                  tableExtractedText: tableExtractedText,
                ),
              ),
            );
          },
          ingredientsExtractedText: _extractedText!,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingredients Image'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    if (_isCameraReady)
                      CameraPreview(_cameraController)
                    else
                      const CircularProgressIndicator(),
                    if (_imageFile != null) Image.file(File(_imageFile!.path)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _isReScan
                    ? ElevatedButton(onPressed: _rescan, child: const Text('Rescan'))
                    : ElevatedButton(
                    onPressed: _takePicture, child: const Text('Take Picture')),
                const SizedBox(width: 16.0),
                _isReScan
                    ? ElevatedButton(onPressed: _route, child: const Text('Next'))
                    : ElevatedButton(
                  onPressed: _pickImage, child: const Text('Select Image'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
