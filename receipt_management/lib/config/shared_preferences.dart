import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceStorage {
  Future createSession(String session) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('session-cookie', session);
    return "Session Saved";
  }

  Future getSession() async {
    final preferences = await SharedPreferences.getInstance();
    String? session = preferences.getString('session-cookie');

    return session;
  }

  Future removeSession() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    return "Session removed";
  }
}
