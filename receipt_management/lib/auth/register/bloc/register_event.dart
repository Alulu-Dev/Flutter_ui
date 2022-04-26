import 'dart:io';

abstract class RegistrationEvent {}

class RegisterEvent extends RegistrationEvent {
  final File profilePic;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  RegisterEvent({
    required this.profilePic,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });
}
