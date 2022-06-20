abstract class RegistrationState {}

class RegisterInProgress extends RegistrationState {}

class Registered extends RegistrationState {}

class UnRegistered extends RegistrationState {}

class RegistrationFailed extends RegistrationState {
  final String errorMsg;

  RegistrationFailed({required this.errorMsg});
}
