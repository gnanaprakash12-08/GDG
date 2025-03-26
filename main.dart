import 'package:flutter/material.dart';
import  'camera_screen.dart';  // Import Camera UI


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint("Using Software Rendering Mode");
  runApp(MaterialApp(
    home: CameraScreen(),  // Start with Camera Module
  ));
}
