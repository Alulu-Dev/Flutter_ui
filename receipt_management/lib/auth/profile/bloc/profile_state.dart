import 'dart:io';

abstract class ProfileState {}

class ProfileUnloaded extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final File profileImage;
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final int receiptData;
  final int requestsData;
  final int daysWithUs;
  ProfileLoaded({
    required this.profileImage,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.receiptData,
    required this.requestsData,
    required this.daysWithUs,
  });
}

class ProfileEditing extends ProfileState {
  final File profileImage;
  final String firstName;
  final String lastName;
  final String email;

  ProfileEditing({
    required this.profileImage,
    required this.firstName,
    required this.lastName,
    required this.email,
  });
}

class ProfileLoggedOut extends ProfileState {}

class ProfileUpdating extends ProfileState {}

class ProfileFailed extends ProfileState {
  final String errorMsg;

  ProfileFailed({required this.errorMsg});
}
