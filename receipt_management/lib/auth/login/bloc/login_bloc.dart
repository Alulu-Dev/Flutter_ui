import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_management/auth/login/bloc/login_event.dart';
import 'package:receipt_management/auth/login/bloc/login_state.dart';
import 'package:receipt_management/auth/login/repository/login_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginRepository loginRepository = LoginRepository();

  AuthBloc() : super(LoggedOut()) {
    on<LoginEvent>(_onLogin);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    try {
      print('here');
      final userName =
          await loginRepository.loginRoute(event.email, event.password);
      print(userName);
      emit(LoginInProgress());
      // await Future.delayed(const Duration(seconds: 2));

      emit(LoggedIn());
    } catch (e) {
      emit(AuthFailed(errorMsg: "Invalid LogIn info"));
    }
  }
}
