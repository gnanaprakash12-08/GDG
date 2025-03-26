import 'dart:convert';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String apiKey = "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"; 
Future<String> detectPests() async {
  try {
    // Pick an image
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      return "No image selected";
    }

    // Read the image as bytes
    Uint8List imageBytes = await pickedFile.readAsBytes();
    String base64Image = base64Encode(imageBytes); // Convert to Base64

    // Send request
    var response = await http.post(
      Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": "Detect pests in this crop image"},
              {
                "inline_data": {
                  "mime_type": "image/jpeg",
                  "data": base64Image
                }
              }
            ]
          }
        ]
      }),
    );

    debugPrint("Response: ${response.body}");
    return response.body;
  } catch (e) {
    debugPrint("Error: $e");
    return "Error detecting pests";
  }
}

