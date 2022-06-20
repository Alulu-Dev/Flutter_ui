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

  Future createSummary(String title, String note, List<Map> receipts) async {
    final sessionID = await _preference.getSession();
    final response = await httpClient.post(
      Uri.parse("$_baseUrl/user-expense/"),
      headers: {
        'cookie': 'session=$sessionID',
        'accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "receipt_list": receipts,
        "title": title,
        "note": note,
      }),
    );
    if (response.statusCode == 200) {
      final _responseBody = jsonDecode(response.body);
      return _responseBody;
    } else {
      throw Exception('Expense Summary Load Failed');
    }
  }

  Future allReceiptSummaries() async {
    final sessionID = await _preference.getSession();
    final response = await httpClient.get(
      Uri.parse("$_baseUrl/user-expense/"),
      headers: {'cookie': 'session=$sessionID'},
    );
    if (response.statusCode == 200) {
      final _responseBody = jsonDecode(response.body);
      return _responseBody;
    } else {
      throw Exception('Expense Summary Load Failed');
    }
  }

  Future receiptSummary(String summaryId) async {
    final sessionID = await _preference.getSession();
    final response = await httpClient.get(
      Uri.parse("$_baseUrl/user-expense/" + summaryId),
      headers: {'cookie': 'session=$sessionID'},
    );

    if (response.statusCode == 200) {
      final _responseBody = jsonDecode(response.body);
      return _responseBody;
    } else {
      throw Exception('Expense Summary Load Failed');
    }
  }

  Future deleteReceiptSummary(String summaryId) async {
    final sessionID = await _preference.getSession();
    final response = await httpClient.delete(
      Uri.parse("$_baseUrl/user-expense/" + summaryId),
      headers: {'cookie': 'session=$sessionID'},
    );
    if (response.statusCode == 200) {
      return response.statusCode;
    } else {
      throw Exception('Expense Summary Load Failed');
    }
  }
}
