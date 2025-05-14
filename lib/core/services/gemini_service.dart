import 'dart:convert';

import 'package:autism_empowering/core/services/api_service.dart';

class GeminiService {
  final ApiService _api = ApiService();
  final _baseUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=";
  Future<Map<String, dynamic>> askGemini({required String question}) async {
    final apiKey = 'AIzaSyCnAXaAQ0INOQexO2NUsnTcz-xRoENHYW8';
    final headers = {'Content-Type': 'application/json'};
    final response = await _api.post(
      url: _baseUrl + apiKey,
      headers: headers,
      body: {
        "contents": [
          {
            "parts": [
              {
                "text": question,
              }
            ]
          }
        ]
      },
    );
    return json.decode(response);
  }
}
