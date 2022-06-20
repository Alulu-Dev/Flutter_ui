import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:receipt_management/config/shared_preferences.dart';

class PredictionProvider {
  final _baseUrl = 'http://127.0.0.1:5000/api/v1/predict/items/';
  final http.Client httpClient;
  final _preference = SharedPreferenceStorage();

  PredictionProvider({required this.httpClient});

  Future getPrediction() async {
    final sessionID = await _preference.getSession();
    final response = await httpClient.get(
      Uri.parse("$_baseUrl/"),
      headers: {'cookie': 'session=$sessionID'},
    );

    if (response.statusCode == 200) {
      final _responseBody = jsonDecode(response.body);
      return _responseBody;
    }
    if (response.statusCode == 400) {
      final _responseBody = jsonDecode(response.body);
      return _responseBody;
    } else {
      throw Exception('Predication Failed to be generated');
    }
  }
}
