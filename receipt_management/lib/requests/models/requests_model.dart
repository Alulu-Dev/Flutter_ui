import 'package:equatable/equatable.dart';

class RequestModel extends Equatable {
  final String id;
  final String name;
  final String status;

  const RequestModel({
    required this.id,
    required this.name,
    required this.status,
  });
  @override
  List<Object?> get props => throw UnimplementedError();

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json['receipt_id'],
      name: json['Receipt'],
      status: json['status'],
    );
  }
}
