// TODO Implement this library.
import 'package:flutter/material.dart';
import 'dart:io';
import 'camera_module.dart';
import 'dashboard.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  File? selectedImage;
  final cameraModule = CameraModule();

  void captureImage() async {
    File? image = await cameraModule.captureImage();
    if (image != null) {
      setState(() => selectedImage = image);
    }
  }

  void pickFromGallery() async {
    File? image = await cameraModule.pickImageFromGallery();
    if (image != null) {
      setState(() => selectedImage = image);
    }
  }

  void goToDashboard() {
    if (selectedImage == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FarmingDashboard(selectedImage: selectedImage),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Capture or Select Image")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            selectedImage != null
                ? Image.file(selectedImage!, height: 150)
                : Text("No image selected"),
            ElevatedButton(onPressed: captureImage, child: Text("Capture Image")),
            ElevatedButton(onPressed: pickFromGallery, child: Text("Select from Gallery")),
            ElevatedButton(onPressed: goToDashboard, child: Text("Proceed to Dashboard")),
          ],
        ),
      ),
    );
  }
}
