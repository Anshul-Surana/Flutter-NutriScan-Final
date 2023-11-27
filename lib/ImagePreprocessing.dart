import 'dart:io';
import 'package:image/image.dart';
import 'package:edge_detection/edge_detection.dart';
import 'package:path_provider/path_provider.dart';

class ImagePreprocessing {
  static Future<File> preprocessImage(File inputImage) async {
    // Load the image
    final Image image = decodeImage(await inputImage.readAsBytes())!;

    // Crop the image around the edges
    final Image croppedImage = _cropImage(image);

    // Rotate the image to correct orientation
    final Image rotatedImage = _correctOrientation(croppedImage);

    // Get the app documents directory
    final appDocumentsDir = await getApplicationDocumentsDirectory();

    // Create a directory for preprocessed images if it doesn't exist
    final preprocessedDir = Directory('${appDocumentsDir.path}/preprocessed_images');
    if (!preprocessedDir.existsSync()) {
      preprocessedDir.createSync();
    }

    // Save the preprocessed image to the created directory
    final preprocessedImagePath =
        '${preprocessedDir.path}/preprocessed_image.jpg';

    await File(preprocessedImagePath).writeAsBytes(encodeJpg(rotatedImage));

    return File(preprocessedImagePath);
  }

  static Image _cropImage(Image image) {
    // Use the edge_detection package to detect edges and crop the image
    final List<int> edges = EdgeDetection.detectEdge(image.getBytes() as String) as List<int>;

    int left = image.width;
    int top = image.height;
    int right = 0;
    int bottom = 0;

    // Find bounding box around edges
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        if (edges[y * image.width + x] != 0) {
          left = x < left ? x : left;
          top = y < top ? y : top;
          right = x > right ? x : right;
          bottom = y > bottom ? y : bottom;
        }
      }
    }

    // Add some padding to the bounding box
    left = (left - 10).clamp(0, image.width - 1);
    top = (top - 10).clamp(0, image.height - 1);
    right = (right + 10).clamp(0, image.width - 1);
    bottom = (bottom + 10).clamp(0, image.height - 1);

    // Crop the image
    return copyCrop(image, x: left, y: top, width: right - left, height: bottom - top);
  }

  static Image _correctOrientation(Image image) {
    // Determine the dominant color channel
    final int sumRed = _sumPixelValues(image, 0);
    final int sumGreen = _sumPixelValues(image, 1);
    final int sumBlue = _sumPixelValues(image, 2);

    // Rotate based on the dominant color channel
    if (sumRed > sumGreen && sumRed > sumBlue) {
      return copyRotate(image, angle: 90);
    } else if (sumGreen > sumRed && sumGreen > sumBlue) {
      return copyRotate(image, angle: 180);
    } else {
      return copyRotate(image, angle: 270);
    }
  }

  static int _sumPixelValues(Image image, int channelIndex) {
    int sum = 0;
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        sum += image.getPixel(x, y)[channelIndex] as int;
      }
    }
    return sum;
  }
}
