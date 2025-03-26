import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class IrrigationManagement extends StatefulWidget {
  @override
  _IrrigationManagementState createState() => _IrrigationManagementState();
}

class _IrrigationManagementState extends State<IrrigationManagement> {
  String irrigationResult = "Click below to check irrigation needs";
  bool isLoading = false;

  Future<void> checkIrrigation() async {
    setState(() => isLoading = true);

    try {
      final response = await http
          .post(
        Uri.parse("http://10.0.2.2:5000/predict_irrigation/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "soil_moisture": 30.5, // Replace with sensor data if available
          "temperature": 25,      // Replace with real-time weather data
          "rainfall": 5,          // Replace with real-time data
          "crop_type": "Wheat",
          "growth_stage": "Flowering"
        }),
      )
          .timeout(Duration(seconds: 10), onTimeout: () {
        setState(() {
          irrigationResult = "Request timed out!";
          isLoading = false;
        });
        return http.Response('{"error": "Timeout"}', 408);
      });

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          irrigationResult = data["irrigation_needed"]
              ? "Irrigation Required: ${data["water_liters"]} Liters"
              : "No irrigation needed.";
          isLoading = false;
        });
      } else {
        setState(() {
          irrigationResult = "Failed to fetch data.";
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        irrigationResult = "Error fetching data";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Irrigation & Water Management")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(irrigationResult, textAlign: TextAlign.center),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: checkIrrigation,
              child: Text("Check Irrigation Needs"),
            ),
          ],
        ),
      ),
    );
  }
}
