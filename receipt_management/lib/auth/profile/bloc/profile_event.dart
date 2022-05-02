import 'dart:io';

abstract class ProfileEvent {}

class ProfileUnload extends ProfileEvent {}

class ProfileLoad extends ProfileEvent {}

class ProfileEdit extends ProfileEvent {}

class ProfileLogout extends ProfileEvent {}

class ProfileSave extends ProfileEvent {
  final File profileImage;
  final String firstName;
  final String lastName;
  final String email;
  final String oldPassword;
  final String password;

  ProfileSave({
    required this.profileImage,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.oldPassword,
    required this.password,
  });
}
