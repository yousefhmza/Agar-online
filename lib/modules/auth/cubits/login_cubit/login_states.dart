import '../../../../core/services/error/failure.dart';

abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class SetPasswordVisibilityState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginSuccessState extends LoginStates {}

class LoginFailureState extends LoginStates {
  final Failure failure;

  LoginFailureState(this.failure);
}

class LogoutSuccessState extends LoginStates {
  final String message;

  LogoutSuccessState(this.message);
}

class LogoutFailureState extends LoginStates {
  final Failure failure;

  LogoutFailureState(this.failure);
}

class SendPasswordLoadingState extends LoginStates {}

class SendPasswordSuccessState extends LoginStates {
  final String message;

  SendPasswordSuccessState(this.message);
}

class SendPasswordFailureState extends LoginStates {
  final Failure failure;

  SendPasswordFailureState(this.failure);
}
