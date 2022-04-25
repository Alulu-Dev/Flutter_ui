import 'package:http/http.dart' as http;
import 'package:receipt_management/config/shared_preferences.dart';

class LoginDataProvider {
  final _baseUrl = 'http://127.0.0.1:5000/api/v1/session';
  final http.Client httpClient;

  final _preference = SharedPreferenceStorage();

  LoginDataProvider({required this.httpClient});

  Future<String> loginRoute(String email, String pass) async {
    final response =
        await httpClient.post(Uri.parse("$_baseUrl/login/$email/$pass/"));

    // session['Set-Cookie']!.split(';')[0].split('=')[1]

    if (response.statusCode == 200) {
      final _responseHeader = response.headers;

      var _session = _responseHeader['set-cookie']!.split(';')[0].split('=')[1];

      await _preference.createSession(_session);
      var username = response.body;

      return username;
    } else {
      throw Exception('Authentication Failed');
    }
  }
}
