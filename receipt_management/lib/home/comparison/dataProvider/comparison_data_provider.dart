import 'dart:convert';

import 'package:receipt_management/config/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ComparisonDataProvider {
  final _baseUrl = 'http://127.0.0.1:5000/api/v1/compare';
  final http.Client httpClient;
  final _preference = SharedPreferenceStorage();
  ComparisonDataProvider({required this.httpClient});

  Future<List> userComparisonList() async {
    final sessionID = await _preference.getSession();
    final response = await httpClient.get(
      Uri.parse("$_baseUrl/results/"),
      headers: {'cookie': 'session=$sessionID'},
    );
    if (response.statusCode == 200) {
      final _responseBody = jsonDecode(response.body);
      return _responseBody;
    } else {
      throw Exception('Comparison List Failed to Load');
    }
  }

  Future comparisonDetailRoute(String recordId) async {
    final sessionID = await _preference.getSession();
    final response = await httpClient.get(
      Uri.parse("$_baseUrl/results/$recordId/"),
      headers: {'cookie': 'session=$sessionID'},
    );
    if (response.statusCode == 200) {
      final _responseBody = jsonDecode(response.body);

      return _responseBody;
    } else {
      throw Exception('Comparison List Failed to Load');
    }
  }

  Future createComparisonRoute(String itemId) async {
    final sessionID = await _preference.getSession();
    final response = await httpClient.post(
      Uri.parse("$_baseUrl/$itemId/"),
      headers: {'cookie': 'session=$sessionID'},
    );
    if (response.statusCode == 200) {
      final _responseBody = jsonDecode(response.body);

      return _responseBody;
    } else {
      throw Exception('Comparison List Failed to Load');
    }
  }

  Future getComparableItems() async {
    final sessionID = await _preference.getSession();
    final response = await httpClient.get(
      Uri.parse("$_baseUrl/items/"),
      headers: {'cookie': 'session=$sessionID'},
    );
    if (response.statusCode == 200) {
      final _responseBody = jsonDecode(response.body);

      return _responseBody;
    } else {
      throw Exception('Failed to Load Items');
    }
  }

  Future updateComparison(String recordId) async {
    final sessionID = await _preference.getSession();
    final response = await httpClient.put(
      Uri.parse("$_baseUrl/results/$recordId/"),
      headers: {'cookie': 'session=$sessionID'},
    );
    if (response.statusCode == 200) {
      final _responseBody = jsonDecode(response.body);

      return _responseBody;
    } else {
      throw Exception('Comparison List Failed to Load');
    }
  }

  Future deleteComparison(String recordId) async {
    final sessionID = await _preference.getSession();
    final response = await httpClient.delete(
      Uri.parse("$_baseUrl/results/$recordId/"),
      headers: {'cookie': 'session=$sessionID'},
    );
    if (response.statusCode == 200) {
      final _responseBody = jsonDecode(response.body);

      return _responseBody;
    } else {
      throw Exception('Comparison List Failed to Load');
    }
  }
}
