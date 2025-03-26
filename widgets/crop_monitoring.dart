import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class CropMonitoring {
  Future<String> analyzeCrop(String imagePath) async {
    final String apiKey = "AIzaSyDF68T3lNEUzPCosQsQrcfb019JbKDD8Aw"; // Replace with your real API key

    // Read image file and convert to Base64
    File imageFile = File(imagePath);
    List<int> imageBytes = await imageFile.readAsBytes();
    String base64Image = base64Encode(imageBytes);

    var response = await http.post(
      Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({

        "contents": [
          {
            "parts": [
              {"text": "Analyze this crop health condition based on the image."},
              {
                "inline_data": {
                  "mime_type": "image/jpeg", // or "image/png"
                  "data": base64Image
                }
              }
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['candidates'][0]['content']['parts'][0]['text'];
    } else {
      return "Error analyzing crop: ${response.statusCode} - ${response.body}";
    }
  }
}
