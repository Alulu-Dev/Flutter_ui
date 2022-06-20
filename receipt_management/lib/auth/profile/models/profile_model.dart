import 'dart:io';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:path_provider/path_provider.dart';

class ProfileModel extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final int receiptCount;
  final int requestCount;
  final int daysWithUs;
  final File profilePicture;

  const ProfileModel(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.receiptCount,
      required this.requestCount,
      required this.daysWithUs,
      required this.profilePicture});
  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
        receiptCount,
        receiptCount,
        daysWithUs,
      ];

  factory ProfileModel.fromJsonAndFile(Map<String, dynamic> json, File image) {
    return ProfileModel(
      id: json['id'],
      firstName: json['firstname'],
      lastName: json['lastname'],
      email: json['email'],
      receiptCount: json['receipt count'],
      requestCount: json['request count'],
      daysWithUs: json['days with us'],
      profilePicture: image,
    );
  }
}
