import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:receipt_management/config/shared_preferences.dart';

class CategorySummaryProvider {
  final _baseUrl = 'http://127.0.0.1:5000/api/v1/summary';
  final http.Client httpClient;
  final _preference = SharedPreferenceStorage();

  CategorySummaryProvider({required this.httpClient});

  Future allCategoriesSummary() async {
    final sessionID = await _preference.getSession();
    final response = await httpClient.get(
      Uri.parse("$_baseUrl/user-category-summary/"),
      headers: {'cookie': 'session=$sessionID'},
    );

    if (response.statusCode == 200) {
      final _responseBody = jsonDecode(response.body);
      return _responseBody;
    } else {
      throw Exception('Expense Summary Load Failed');
    }
  }

  Future singleCategoriesSummary(String catId) async {
    final sessionID = await _preference.getSession();
    final response = await httpClient.get(
      Uri.parse("$_baseUrl/user-category-details/$catId"),
      headers: {'cookie': 'session=$sessionID'},
    );

    if (response.statusCode == 200) {
      final _responseBody = jsonDecode(response.body);

      return _responseBody;
    } else {
      throw Exception('Expense Summary Load Failed');
    }
  }
}
