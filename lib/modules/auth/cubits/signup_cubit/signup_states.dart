import '../../../../core/services/error/failure.dart';

abstract class SignupStates {}

class SignupInitialState extends SignupStates {}

class SetTermsAgreementState extends SignupStates {}

class SetPasswordVisibilityState extends SignupStates {}

class SignupLoadingState extends SignupStates {}

class SignupSuccessState extends SignupStates {}

class SignupFailureState extends SignupStates {
  final Failure failure;

  SignupFailureState(this.failure);
}
