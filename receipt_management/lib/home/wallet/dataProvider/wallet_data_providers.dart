import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:receipt_management/config/shared_preferences.dart';

class WalletListProvider {
  final _baseUrl = 'http://127.0.0.1:5000/api/v1';
  final http.Client httpClient;

  final _preference = SharedPreferenceStorage();

  WalletListProvider({required this.httpClient});

  Future<List> userWalletRoute() async {
    final sessionID = await _preference.getSession();
    final response = await httpClient.get(
      Uri.parse("$_baseUrl/receipt/"),
      headers: {'cookie': 'session=$sessionID'},
    );

    if (response.statusCode == 200) {
      final _responseBody = jsonDecode(response.body);

      return _responseBody;
    } else {
      throw Exception('Receipt Load Failed');
    }
  }

  Future<List> receiptDetails(String receiptID) async {
    final sessionID = await _preference.getSession();

    final responseDetails = await httpClient.get(
      Uri.parse("$_baseUrl/receipt/get_data/$receiptID/"),
      headers: {'cookie': 'session=$sessionID'},
    );
    final responseImage = await httpClient.get(
      Uri.parse("$_baseUrl/receipt/get_image/$receiptID/"),
      headers: {'cookie': 'session=$sessionID'},
    );

    if (responseDetails.statusCode == 200) {
      final _responseBody = jsonDecode(responseDetails.body);

      if (responseImage.statusCode == 200) {
        final Uint8List imageBytes =
            responseImage.bodyBytes.buffer.asUint8List();
        return [_responseBody, imageBytes];
      }

      return [_responseBody];
    } else {
      throw Exception('Authentication Failed');
    }
  }

  Future<String> receiptVerificationStatusCheck(String _receiptId) async {
    final _sessionID = await _preference.getSession();

    final _response = await httpClient.get(
      Uri.parse("$_baseUrl/request/$_receiptId/"),
      headers: {'cookie': 'session=$_sessionID'},
    );

    if (_response.statusCode == 200) {
      final _requestResponse = jsonDecode(_response.body);
      return _requestResponse.toString();
    } else {
      throw Exception('Authentication Failed');
    }
  }

  Future<String> receiptVerificationRequest(String _receiptId) async {
    final _sessionID = await _preference.getSession();

    final _response = await httpClient.post(
      Uri.parse("$_baseUrl/request/$_receiptId/"),
      headers: {'cookie': 'session=$_sessionID'},
    );

    if (_response.statusCode == 201) {
      final _requestResponse = jsonDecode(_response.body);
      return _requestResponse;
    } else {
      throw Exception('Authentication Failed');
    }
  }
}
