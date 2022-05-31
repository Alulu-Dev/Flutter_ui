import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:receipt_management/config/shared_preferences.dart';

class ReceiptUploadProvider {
  final _baseUrl = 'http://127.0.0.1:5000/api/v1/Receipt Scan';
  final http.Client httpClient;
  late http.MultipartRequest httpMultipartRequest;

  final _preference = SharedPreferenceStorage();
  ReceiptUploadProvider({required this.httpClient});

  Future<String> imageRoute(File receipt) async {
    final sessionID = await _preference.getSession();
    httpMultipartRequest =
        http.MultipartRequest("POST", Uri.parse("$_baseUrl/Scan"));
    httpMultipartRequest.headers.addAll({'cookie': 'session=$sessionID'});

    httpMultipartRequest.files.add(await http.MultipartFile.fromPath(
      "file",
      receipt.path,
      contentType: MediaType('image', '*'),
    ));

    final _response = await httpMultipartRequest.send();
    print(123);
    if (_response.statusCode == 200) {
      return _response.statusCode.toString();
    } else {
      throw Exception('Failed to upload Receipt Image');
    }
  }
}
