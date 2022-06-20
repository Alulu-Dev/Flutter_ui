import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_management/requests/bloc/request_event.dart';
import 'package:receipt_management/requests/bloc/request_state.dart';
import 'package:receipt_management/requests/repository/request_repository.dart';

class UserRequestBloc extends Bloc<UserRequestEvent, UserRequestState> {
  final RequestRepository budgetRepository = RequestRepository();
  UserRequestBloc() : super(RequestInitial()) {
    on<RequestLoad>(_onRequestLoad);
    on<RequestUnLoad>(_onRequestUnLoad);
  }

  Future<void> _onRequestLoad(
      RequestLoad event, Emitter<UserRequestState> emit) async {
    try {
      final _requests = await budgetRepository.allRequest();
      emit(RequestLoaded(requests: _requests));
    } catch (e) {
      emit(RequestFailed(errorMsg: e.toString()));
    }
  }

  Future<void> _onRequestUnLoad(
      RequestUnLoad event, Emitter<UserRequestState> emit) async {
    try {
      emit(RequestInitial());
    } catch (e) {
      emit(RequestFailed(errorMsg: e.toString()));
    }
  }
}
