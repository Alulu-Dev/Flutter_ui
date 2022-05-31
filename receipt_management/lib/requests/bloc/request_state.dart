import 'package:receipt_management/requests/models/requests_model.dart';

abstract class UserRequestState {}

class RequestInitial extends UserRequestState {}

class RequestLoaded extends UserRequestState {
  final List<RequestModel> requests;
  RequestLoaded({required this.requests});
}

class RequestFailed extends UserRequestState {
  final String errorMsg;
  RequestFailed({required this.errorMsg});
}
