import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const String apiKey = "YOUR_OPENAI_API_KEY";
  static const String apiUrl = "https://api.openai.com/v1/chat/completions";

  Future<String> getPlantingAdvice(String cropName) async {
    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $apiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {"role": "system", "content": "You are an AI farming assistant."},
            {"role": "user", "content": "Best planting time for $cropName?"}
          ],
          "max_tokens": 100,
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        return "Error: Unable to fetch planting time.";
      }
    } catch (e) {
      return "Error: $e";
    }
  }
}
