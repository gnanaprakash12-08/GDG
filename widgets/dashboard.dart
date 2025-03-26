import 'package:flutter/material.dart';
import 'dart:io';
import 'crop_monitoring.dart';
import 'pest_detection.dart';
import 'resource_optimization.dart';
import 'irrigation_management.dart';
//import 'package:your_project/lib/pest_detection.dart';


class FarmingDashboard extends StatefulWidget {
  final File? selectedImage;

  FarmingDashboard({required this.selectedImage});

  @override
  _FarmingDashboardState createState() => _FarmingDashboardState();
}

class _FarmingDashboardState extends State<FarmingDashboard> {
  String result = "";
  final cropMonitor = CropMonitoring();
  final pestDetect = PestDetection();
  final resourceOpt = ResourceOptimization();

  void analyzeCrop() async {
    if (widget.selectedImage == null) return;
    String analysis = await cropMonitor.analyzeCrop(widget.selectedImage!.path);
    setState(() => result = analysis);
  }

  void detectPest() async {
    if (widget.selectedImage == null) return;
    String detection = await pestDetect.detectPest(widget.selectedImage!.path);
    setState(() => result = detection);
  }

  void optimizeResources() async {
    try {
      String optimization = await resourceOpt.optimizeResources("How to optimize water usage?");
      print("API Response: $optimization"); // Debugging
      setState(() => result = optimization);
    } catch (e) {
      print("Error: $e"); // Debugging
      setState(() => result = "Error: ${e.toString()}");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AI Farming Assistant")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.selectedImage != null
                ? Image.file(widget.selectedImage!, height: 150)
                : Text("No image provided"),
            ElevatedButton(onPressed: analyzeCrop, child: Text("Analyze Crop")),
            ElevatedButton(onPressed: detectPest, child: Text("Detect Pest")),
            ElevatedButton(onPressed: optimizeResources, child: Text("Optimize Resources")),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => IrrigationManagement()),
                );
              },
              child: Text("Irrigation Management"),
            ),

            Text(result),
          ],
        ),
      ),
    );
  }
}

class PestDetection {
  PestDetection();

  Future<String> detectPest(String imagePath) async {
    // Simulating pest detection logic
    return "Pest detected in image: $imagePath";
  }
}

