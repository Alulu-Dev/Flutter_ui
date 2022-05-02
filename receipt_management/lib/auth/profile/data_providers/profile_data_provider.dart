import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:receipt_management/config/shared_preferences.dart';

class ProfileProvider {
  final _baseUrl = 'http://127.0.0.1:5000/api/v1/account';
  final http.Client httpClient;
  late http.MultipartRequest httpMultipartRequest;

  final _preference = SharedPreferenceStorage();

  ProfileProvider({required this.httpClient});

  Future<List> profileRoute() async {
    final sessionID = await _preference.getSession();

    final response = await httpClient.get(
      Uri.parse("$_baseUrl/user/"),
      headers: {'cookie': 'session=$sessionID'},
    );
    if (response.statusCode == 200) {
      final _profileData = response.headers['data']!;
      final _formattedData = _profileData.replaceAll("'", "\"");
      final _json = jsonDecode(_formattedData);
      final _profileImage = response.bodyBytes;
      return [_profileImage, _json];
    } else {
      throw Exception('Profile Loading Failed');
    }
  }

  Future<String> profileUpdate(
    File profileImage,
    String firstName,
    String lastName,
    String email,
    String oldPassword,
    String password,
  ) async {
    final sessionID = await _preference.getSession();

    httpMultipartRequest =
        http.MultipartRequest("PUT", Uri.parse("$_baseUrl/user/"));
    httpMultipartRequest.headers.addAll({'cookie': 'session=$sessionID'});
    httpMultipartRequest.fields["firstname"] = firstName;
    httpMultipartRequest.fields["lastname"] = lastName;
    httpMultipartRequest.fields["email"] = email;
    httpMultipartRequest.fields["old-password"] = oldPassword;
    httpMultipartRequest.fields["password"] = password;
    httpMultipartRequest.files.add(await http.MultipartFile.fromPath(
      "file",
      profileImage.path,
      contentType: MediaType('image', 'jpeg'),
    ));

    final _responses = await httpMultipartRequest.send();
    if (_responses.statusCode == 200) {
      return "Uploaded!";
    } else {
      throw Exception('Profile Loading Failed');
    }
  }
}
