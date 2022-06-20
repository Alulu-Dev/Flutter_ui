import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:receipt_management/config/shared_preferences.dart';

class BudgetProvider {
  final _baseUrl = 'http://127.0.0.1:5000/api/v1/summary';
  final http.Client httpClient;
  final _preference = SharedPreferenceStorage();

  BudgetProvider({required this.httpClient});

  Future allBudgets() async {
    final sessionID = await _preference.getSession();
    final response = await httpClient.get(
      Uri.parse("$_baseUrl/user-budget"),
      headers: {'cookie': 'session=$sessionID'},
    );

    if (response.statusCode == 200) {
      final _responseBody = jsonDecode(response.body);
      return _responseBody;
    } else {
      throw Exception('Budget Load Failed');
    }
  }

  Future setBudget(String catId, String amount) async {
    final sessionID = await _preference.getSession();
    final response = await httpClient.post(
      Uri.parse("$_baseUrl/user-add-budget/$catId/$amount"),
      headers: {'cookie': 'session=$sessionID'},
    );

    if (response.statusCode == 200) {
      final _responseBody = jsonDecode(response.body);

      return _responseBody;
    } else {
      throw Exception('Budget Creation Failed');
    }
  }

  Future getAllCategories() async {
    final sessionID = await _preference.getSession();
    final response = await httpClient.get(
      Uri.parse("$_baseUrl/categories"),
      headers: {'cookie': 'session=$sessionID'},
    );

    if (response.statusCode == 200) {
      final _responseBody = jsonDecode(response.body);

      return _responseBody;
    } else {
      throw Exception('Budget Creation Failed');
    }
  }
}
