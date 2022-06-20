import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_management/auth/register/bloc/bloc.dart';
import 'package:receipt_management/auth/register/repository/register_repository.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final RegisterRepository registerRepository = RegisterRepository();

  RegistrationBloc() : super(UnRegistered()) {
    on<RegisterEvent>(_onRegistration);
  }

  Future<void> _onRegistration(
      RegisterEvent event, Emitter<RegistrationState> emit) async {
    try {
      // await loginRepository.loginRoute(event.email, event.password);
      emit(RegisterInProgress());

      final _res = registerRepository.registerRoute(
        event.profilePic,
        event.firstName,
        event.lastName,
        event.email,
        event.password,
      );
      print(event.profilePic);
      emit(Registered());
    } catch (e) {
      emit(RegistrationFailed(errorMsg: "Registration FFailed Try Again!"));
    }
  }
}
