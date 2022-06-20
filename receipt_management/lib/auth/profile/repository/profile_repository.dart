import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:receipt_management/auth/profile/data_providers/profile_data_provider.dart';
import 'package:receipt_management/auth/profile/models/profile_model.dart';

class ProfileRepository {
  final ProfileProvider profileProvider =
      ProfileProvider(httpClient: http.Client());

  Future<ProfileModel> profileRoute() async {
    try {
      final _response = await profileProvider.profileRoute();
      final _image = await getImageFileFromByte(_response[0]);
      final _profile = ProfileModel.fromJsonAndFile(_response[1], _image);
      return _profile;
    } catch (e) {
      throw Exception('Not Profile Object');
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
    try {
      final _response = profileProvider.profileUpdate(
        profileImage,
        firstName,
        lastName,
        email,
        oldPassword,
        password,
      );
      return _response;
    } catch (e) {
      throw Exception('Profile Update Failed');
    }
  }

  Future deleteProfile() async {
    try {
      final _response = await profileProvider.deleteProfile();
      return _response;
    } catch (e) {
      rethrow;
    }
  }
}

Future<File> getImageFileFromByte(Uint8List byte) async {
  try {
    final tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/image.jpg').create();
    file.writeAsBytes(byte);
    return file;
  } catch (e) {
    throw Exception('not today');
  }
}
