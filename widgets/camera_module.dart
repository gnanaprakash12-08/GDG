import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class CameraModule {
  final ImagePicker _picker = ImagePicker();

  // Pick an image from the camera
  Future<File?> captureImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  // Pick an image from the gallery
  Future<File?> pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  // Send image to AI for analysis
  Future<Map<String, dynamic>> analyzeCrop(File imageFile) async {
    var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://your-ai-api.com/analyze')
      // Replace with your API endpoint
    );
    request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    var response = await request.send();
    var responseData = await response.stream.bytesToString();
    return jsonDecode(responseData);
  }
}
