import 'package:http/http.dart' as http;
import 'package:receipt_management/auth/login/data_providers/login_data_provider.dart';

class LoginRepository {
  final LoginDataProvider loginDataProvider =
      LoginDataProvider(httpClient: http.Client());

  // LoginRepository();

  Future<String> loginRoute(String email, String pass) async {
    return await loginDataProvider.loginRoute(email, pass);
  }
}
