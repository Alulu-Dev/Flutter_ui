import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:receipt_management/config/shared_preferences.dart';

class RegisterDataProvider {
  final _baseUrl = 'http://0.0.0.0:5000/api/v1/account/signup';
  final http.Client httpClient;
  late http.MultipartRequest httpMultipartRequest;

  final _preference = SharedPreferenceStorage();

  RegisterDataProvider({required this.httpClient});

  Future<String> registerRoute(
    File file,
    String firstName,
    String lastName,
    String email,
    String pass,
  ) async {
    httpMultipartRequest =
        http.MultipartRequest("POST", Uri.parse("$_baseUrl/user/"));
    httpMultipartRequest.fields["firstname"] = firstName;
    httpMultipartRequest.fields["lastname"] = lastName;
    httpMultipartRequest.fields["email"] = email;
    httpMultipartRequest.fields["password"] = pass;
    httpMultipartRequest.files.add(await http.MultipartFile.fromPath(
      "file",
      file.path,
      contentType: MediaType('image', 'jpeg'),
    ));
    final _responses = await httpMultipartRequest.send();
    if (_responses.statusCode == 200) {
      final _responseHeader = _responses.headers;
      var _session = _responseHeader['Set-Cookie']!.split(';')[0].split('=')[1];

      await _preference.createSession(_session);
      var status = _responses.statusCode.toString();
      return status;
    } else {
      throw Exception('Authentication Failed');
    }
  }
}
