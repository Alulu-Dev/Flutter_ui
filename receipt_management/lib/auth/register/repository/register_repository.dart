import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:receipt_management/auth/register/data_providers/register_data_provider.dart';

class RegisterRepository {
  final RegisterDataProvider loginDataProvider =
      RegisterDataProvider(httpClient: http.Client());

  RegisterRepository();

  Future<String> registerRoute(
    File file,
    String firstName,
    String lastName,
    String email,
    String pass,
  ) async {
    return await loginDataProvider.registerRoute(
      file,
      firstName,
      lastName,
      email,
      pass,
    );
  }
}
